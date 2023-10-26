import 'dart:convert';
import 'dart:io';
import 'package:a2dika/list_data.dart';
import 'package:a2dika/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TambahData extends StatefulWidget {
  const TambahData({Key? key}) : super(key: key);
  @override
  _TambahDataState createState() => _TambahDataState();
}

class _TambahDataState extends State<TambahData> {
  final _formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final jenisController = TextEditingController();
  final warnaController = TextEditingController();
  final habitatController = TextEditingController();
  Future postData(
      String nama, String jenis, String warna, String habitat) async {
    // print(nama);
    String url = Platform.isAndroid
        ? 'https://responsi1a.dalhaqq.xyz/ikan'
        : 'https://responsi1a.dalhaqq.xyz/ikan';
    //String url = 'http://127.0.0.1/apiTrash/prosesLoginDriver.php';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody =
        '{"nama": "$nama", "jenis": "$jenis","warna": "$warna", "habitat": "$habitat"}';
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add data');
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
          title: const Text('Tambah Data Ikan'),
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
                  child: const Text('Tambah Ikan'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String nama = namaController.text;
                      String jenis = jenisController.text;
                      String warna = warnaController.text;
                      String habitat = habitatController.text;
                      // print(nama);
                      postData(nama, jenis, warna, habitat).then((result) {
                        //print(result['pesan']);
                        if (result['status'] == true) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                //var namauser2 = namauser;
                                return AlertDialog(
                                  title: const Text('Data berhasil ditambah'),
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
