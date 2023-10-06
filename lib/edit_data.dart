import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uts/list_data.dart';

class EditData extends StatefulWidget {
  final String id;
  final String nama;
  final String jurusan;

  const EditData(
      {Key? key, required this.id, required this.nama, required this.jurusan})
      : super(key: key);

  @override
  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  final namaController = TextEditingController();
  final jurusanController = TextEditingController();

  Future<bool> editData(String id) async {
    // String url = Platform.isAndroid
    //     ? 'http://10.100.0.144/api/index.php'
    //     : 'http://localhost/api/index.php';
    String url = "http://192.168.1.12:8080/pemob1/index.php";
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody =
        '{"id": "${widget.id}", "nama": "${namaController.text}", "jurusan": "${jurusanController.text}"}';
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
    namaController.value = TextEditingValue(text: widget.nama);
    jurusanController.value = TextEditingValue(text: widget.jurusan);
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
