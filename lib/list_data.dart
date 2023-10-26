import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:a2dika/side_menu.dart';
import 'package:a2dika/tambah_data.dart';
import 'package:a2dika/edit_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListData extends StatefulWidget {
  const ListData({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _ListDataState createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
  List<Map<String, String>> dataIkan = [];
  String url = Platform.isAndroid
      ? 'https://responsi1a.dalhaqq.xyz/ikan'
      : 'https://responsi1a.dalhaqq.xyz/ikan';
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if ((response.statusCode == 200)) {
      final List<dynamic> data = json.decode(response.body)['data'];
      setState(() {
        dataIkan = List<Map<String, String>>.from(data.map((item) {
          return {
            'nama': item['nama'] as String,
            'jenis': item['jenis'] as String,
            'warna': item['warna'] as String,
            'habitat': item['habitat'] as String,
            'id': item['id'] as String,
          };
        }));
      });
    }
  }

  Future deleteData(int id) async {
    final response = await http.delete(Uri.parse('$url/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('List Data Ikan'),
        ),
        drawer: const SideMenu(),
        body: Column(children: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const TambahData(),
                ),
              );
            },
            child: const Text('Tambah Data Ikan'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dataIkan.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(dataIkan[index]['nama']!),
                  subtitle: Text('Jenis: ${dataIkan[index]['jenis']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.visibility),
                        onPressed: () {
                          //lihatMahasiswa(index);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    title: Text('${dataIkan[index]['nama']}'),
                                    content: Text(
                                        'Jenis : ${dataIkan[index]['jenis']}\n'
                                        'Warna : ${dataIkan[index]['warna']}\n'
                                        'Habitat : ${dataIkan[index]['habitat']}')
                                    // actions: [
                                    //   TextButton(
                                    //     child: const Text('OK'),
                                    //     onPressed: () {
                                    //       Navigator.push(
                                    //         context,
                                    //         MaterialPageRoute(
                                    //           builder: (context) =>
                                    //               const HomePage(),
                                    //         ),
                                    //       );
                                    //     },
                                    //   ),
                                    //   ],
                                    );
                              });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          //editMahasiswa(index);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditData(
                                      id: int.parse(dataIkan[index]['id']!),
                                      nama: '${dataIkan[index]['nama']}',
                                      jenis: '${dataIkan[index]['jenis']}',
                                      warna: '${dataIkan[index]['warna']}',
                                      habitat:
                                          '${dataIkan[index]['habitat']}')));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteData(int.parse(dataIkan[index]['id']!))
                              .then((result) {
                            if (result['data'] == true) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title:
                                          const Text('Data berhasil dihapus'),
                                      // content: const Text('ok'),
                                      actions: [
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.pushReplacement(
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
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ]));
  }
}
