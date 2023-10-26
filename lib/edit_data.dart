import 'dart:convert';
import 'dart:io';
import 'package:a2dika/list_data.dart';
import 'package:a2dika/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditData extends StatefulWidget {
  final int id;
  final String nama, jenis, warna, habitat;
  const EditData(
      {Key? key,
      required this.id,
      required this.nama,
      required this.jenis,
      required this.warna,
      required this.habitat})
      : super(key: key);
  @override
  _EditDataState createState() =>
      _EditDataState(id, nama, jenis, warna, habitat);
}

class _EditDataState extends State<EditData> {
  int? id;
  String? nama, jenis, warna, habitat;
  _EditDataState(
      int id, String nama, String jenis, String warna, String habitat) {
    this.id = id;
    this.nama = nama;
    this.jenis = jenis;
    this.warna = warna;
    this.habitat = habitat;
    namaController.text = nama;
    jenisController.text = jenis;
    warnaController.text = warna;
    habitatController.text = habitat;
  }
  final _formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final jenisController = TextEditingController();
  final warnaController = TextEditingController();
  final habitatController = TextEditingController();
  Future putData(
      int? id, String nama, String jenis, String warna, String habitat) async {
    // print(nama);
    String url = Platform.isAndroid
        ? 'https://responsi1a.dalhaqq.xyz/ikan'
        : 'https://responsi1a.dalhaqq.xyz/ikan';
    //String url = 'http://127.0.0.1/apiTrash/prosesLoginDriver.php';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody =
        '{"id":"$id","nama": "$nama", "jenis": "$jenis","warna": "$warna", "habitat": "$habitat"}';
    var response = await http.put(
      Uri.parse('$url/$id'),
      headers: headers,
      body: jsonBody,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to edit data');
    }
  }

  _buatInput(control, String hint) {
    return TextFormField(
      controller: control,
      decoration: InputDecoration(
        hintText: hint,
      ),
      validator: (String? value) {
        return (value == null || value.isEmpty)
            ? "Please enter some text"
            : null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Data Ikan'),
        ),
        drawer: const SideMenu(),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buatInput(namaController, 'Masukkan Nama Ikan'),
                _buatInput(jenisController, 'Masukkan Jenis Ikan'),
                _buatInput(warnaController, 'Masukkan Warna Ikan'),
                _buatInput(habitatController, 'Masukkan Habitat Ikan'),
                ElevatedButton(
                  child: const Text('Edit Ikan'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String nama = namaController.text;
                      String jenis = jenisController.text;
                      String warna = warnaController.text;
                      String habitat = habitatController.text;
                      // print(nama);
                      putData(id, nama, jenis, warna, habitat).then((result) {
                        if (result['status'] == 'true') {
                          showDialog(
                              context: context,
                              builder: (context) {
                                //var namauser2 = namauser;
                                return AlertDialog(
                                  title: const Text('Data berhasil diupdate'),
                                  // content: const Text('ok'),
                                  actions: [
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ListData(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              });
                        }
                        setState(() {});
                      });
                    }
                  },
                ),
              ],
              // Tugas Kelompok • Lanjutkan untuk delete data, edit data, dan rea
            ),
          ),
        ));
  }
}
