// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uts/list_data.dart';
import 'package:uts/side_menu.dart';

class TambahData extends StatefulWidget {
  const TambahData({Key? key}) : super(key: key);

  @override
  _TambahDataState createState() => _TambahDataState();
}

class _TambahDataState extends State<TambahData> {
  final namaController = TextEditingController();
  final jurusanController = TextEditingController();

  Future postData(String nama, String jurusan) async {
    // String url = Platform.isAndroid
    //     ? 'http://10.100.0.144/api/index.php'
    //     : 'http://localhost/api/index.php';
    String url = "http://192.168.1.12:8080/pemob1/index.php";
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody = '{"nama": "$nama", "jurusan": "$jurusan"}';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Data Mahasiswa'),
      ),
      drawer: const SideMenu(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                hintText: 'Nama Mahasiswa',
              ),
            ),
            TextField(
              controller: jurusanController,
              decoration: const InputDecoration(
                hintText: 'Jurusan',
              ),
            ),
            ElevatedButton(
              child: const Text('Tambah Mahasiswa'),
              onPressed: () {
                String nama = namaController.text;
                String jurusan = jurusanController.text;
                // print(nama);
                postData(nama, jurusan).then((result) {
                  //print(result['pesan']);
                  if (result['pesan'] == 'berhasil') {
                    showDialog(
                        context: context,
                        builder: (context) {
                          //var namauser2 = namauser;
                          return AlertDialog(
                            title: const Text('Data berhasil di tambah'),
                            content: const Text('ok'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ListData(),
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
              },
            ),
          ],
        ),

        // ],
        // ),
        // ),
      ),
    );
  }
}
