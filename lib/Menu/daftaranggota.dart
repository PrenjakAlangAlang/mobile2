import 'package:flutter/material.dart';

class DaftarAnggota extends StatefulWidget {
  const DaftarAnggota({super.key});

  @override
  State<DaftarAnggota> createState() => _DaftarAnggotaState();
}

class _DaftarAnggotaState extends State<DaftarAnggota> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Anggota'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Ahmad Faiq Syahputra'),
            subtitle: Text('124220013'),
          ),
          ListTile(
            title: Text('Luthfi Nurafiq Asshiddiqi'),
            subtitle: Text('124220021'),
          ),
        ],
      ),
    );
  }
}
