import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uts/list_data.dart';

class EditData extends StatefulWidget {
  final String id;
  final String deskripsi_transaksi;
  final String jumlah;

  const EditData(
      {Key? key,
      required this.id,
      required this.deskripsi_transaksi,
      required this.jumlah})
      : super(key: key);

  @override
  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  final deskripsiTransaksiController = TextEditingController();
  final jumlahController = TextEditingController();

  Future<bool> editData(String id) async {
    // String url = Platform.isAndroid
    //     ? 'http://10.100.0.144/api/index.php'
    //     : 'http://localhost/api/index.php';
    String url = "http://192.168.43.17:8080/uts/index.php";
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody =
        '{"id": "${widget.id}", "deskripsi_transaksi": "${deskripsiTransaksiController.text}", "jumlah": "${jumlahController.text}"}';
    var response =
        await http.put(Uri.parse(url), body: jsonBody, headers: headers);
    if (response.statusCode == 200) {
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => const ListData()));
      return true;
    } else {
      print('Error');
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deskripsiTransaksiController.value =
        TextEditingValue(text: widget.deskripsi_transaksi);
    jumlahController.value = TextEditingValue(text: widget.jumlah);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              onPressed: () async {
                await editData(widget.id)
                    ? showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Success"),
                            content: const Text("Data berhasil di edit."),
                            actions: <Widget>[
                              TextButton(
                                child: const Text("OK"),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const ListData()));
                                },
                              ),
                            ],
                          );
                        },
                      )
                    : false;
              },
              child: const Text("Edit"),
            ),
          ],
        ),
      ),
    );
  }
}
