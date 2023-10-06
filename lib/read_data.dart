import 'package:flutter/material.dart';

class ReadData extends StatelessWidget {
  final String id;
  final String deskripsi_transaksi;
  final String jumlah;

  const ReadData(
      {Key? key,
      required this.id,
      required this.deskripsi_transaksi,
      required this.jumlah})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lihat Data"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Text(
              'ID: $id',
              style: const TextStyle(
                fontSize: 18, // Adjust the font size as needed
                fontWeight: FontWeight.bold, // Add emphasis with bold text
              ),
            ),
            const SizedBox(
              height: 10,
            ), // Add some spacing between the text widgets
            Text(
              'Deskripsi Transaksi: $deskripsi_transaksi',
              style: const TextStyle(
                fontSize: 16, // Adjust the font size as needed
              ),
            ),
            const SizedBox(height: 5), // Add a smaller spacing
            Text(
              'Jumlah: $jumlah',
              style: const TextStyle(
                fontSize: 16, // Adjust the font size as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}
