import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uts/edit_data.dart';
import 'package:uts/read_data.dart';
import 'package:uts/side_menu.dart';
import 'package:uts/tambah_data.dart';

class ListData extends StatefulWidget {
  const ListData({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListDataState createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
  List<Map<String, String>> dataTransaksi = [];
  String url = Platform.isAndroid
      ? 'http://192.168.36.70:8080/uts/index.php'
      : 'http://localhost:8080/uts/index.php';
  // String url = "http://169.254.21.151:8080/uts/index.php";
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        dataTransaksi = List<Map<String, String>>.from(data.map((item) {
          return {
            'deskripsi_transaksi': item['deskripsi_transaksi'] as String,
            'jumlah': item['jumlah'] as String,
            'id': item['id'] as String,
          };
        }));
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future deleteData(int id) async {
    final response = await http.delete(Uri.parse('$url?id=$id'));
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
        title: const Text('List Data Transaksi'),
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
          child: const Text('Tambah Data Transaksi'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: dataTransaksi.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(dataTransaksi[index]['deskripsi_transaksi']!),
                subtitle: Text('Jumlah: ${dataTransaksi[index]['jumlah']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ReadData(
                                id: dataTransaksi[index]['id'].toString(),
                                deskripsi_transaksi: dataTransaksi[index]
                                    ['deskripsi_transaksi'] as String,
                                jumlah:
                                    dataTransaksi[index]['jumlah'] as String)));
                        //editTransaksi(index);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // lihatTransaksi(aindex);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditData(
                                id: dataTransaksi[index]['id'].toString(),
                                deskripsi_transaksi: dataTransaksi[index]
                                    ['deskripsi_transaksi'] as String,
                                jumlah:
                                    dataTransaksi[index]['jumlah'] as String)));
                        //editTransaksi(index);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        deleteData(int.parse(dataTransaksi[index]['id']!))
                            .then((result) {
                          if (result['pesan'] == 'berhasil') {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Data berhasil di hapus'),
                                    content: const Text('ok'),
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
        )
      ]),
    );
  }
}
