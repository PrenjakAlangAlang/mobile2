import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class DaftarRekomendasi extends StatefulWidget {
  @override
  _DaftarRekomendasiState createState() => _DaftarRekomendasiState();
}

class _DaftarRekomendasiState extends State<DaftarRekomendasi> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _rekomendasiList = [];

  @override
  void initState() {
    super.initState();
    _fetchRekomendasi();
  }

  Future<void> _fetchRekomendasi() async {
    QuerySnapshot snapshot = await _firestore.collection('rekomendasi').get();
    setState(() {
      _rekomendasiList = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  Future<void> _updateFavorit(String id, bool isFavorit) async {
    final user = _auth.currentUser;
    if (user == null) return;

    DocumentSnapshot doc =
        await _firestore.collection('rekomendasi').doc(id).get();
    List<dynamic> favorit = doc['favorit'] ?? [];

    if (isFavorit) {
      if (!favorit.contains(user.uid)) {
        favorit.add(user.uid);
      }
    } else {
      favorit.remove(user.uid);
    }

    await _firestore.collection('rekomendasi').doc(id).update({
      'favorit': favorit,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Rekomendasi'),
      ),
      body: ListView.builder(
        itemCount: _rekomendasiList.length,
        itemBuilder: (context, index) {
          var rekomendasi = _rekomendasiList[index];
          bool isFavorit =
              rekomendasi['favorit']?.contains(_auth.currentUser?.uid) ?? false;

          return ListTile(
            leading: Image.network(rekomendasi['image']),
            title: Text(rekomendasi['title']),
            subtitle: InkWell(
              onTap: () => launchUrll(rekomendasi['url']),
              child: Text(
                rekomendasi['url'],
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            trailing: Checkbox(
              value: isFavorit,
              onChanged: (bool? value) {
                setState(() {
                  isFavorit = value ?? false;
                  if (value == true) {
                    _rekomendasiList[index]['favorit'] =
                        _rekomendasiList[index]['favorit'] ?? [];
                    _rekomendasiList[index]['favorit']
                        .add(_auth.currentUser!.uid);
                  } else {
                    _rekomendasiList[index]['favorit']
                        .remove(_auth.currentUser!.uid);
                  }
                });
                _updateFavorit(rekomendasi['id'], isFavorit);
              },
            ),
          );
        },
      ),
    );
  }

  void launchUrll(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
