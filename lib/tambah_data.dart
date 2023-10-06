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
  final deskripsiTransaksiController = TextEditingController();
  final jumlahController = TextEditingController();

  Future postData(String deskripsi_transaksi, String jumlah) async {
    // String url = Platform.isAndroid
    //     ? 'http://10.100.0.144/api/index.php'
    //     : 'http://localhost/api/index.php';
    String url = "http://192.168.43.17:8080/uts/index.php";
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody =
        '{"deskripsi_transaksi": "$deskripsi_transaksi", "jumlah": "$jumlah"}';
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
        title: const Text('Tambah Data Transaksi'),
      ),
      drawer: const SideMenu(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: deskripsiTransaksiController,
              decoration: const InputDecoration(
                hintText: 'Deskripsi Transaksi',
              ),
            ),
            TextField(
              controller: jumlahController,
              decoration: const InputDecoration(
                hintText: 'Jumlah',
              ),
            ),
            ElevatedButton(
              child: const Text('Tambah Transaksi'),
              onPressed: () {
                String deskripsi_transaksi = deskripsiTransaksiController.text;
                String jumlah = jumlahController.text;
                // print(desk_transaksi);
                postData(deskripsi_transaksi, jumlah).then((result) {
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
