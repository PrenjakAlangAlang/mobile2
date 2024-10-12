import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class Favorit extends StatefulWidget {
  @override
  _FavoritState createState() => _FavoritState();
}

class _FavoritState extends State<Favorit> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _favoritList = [];

  @override
  void initState() {
    super.initState();
    _fetchFavorit();
  }

  Future<void> _fetchFavorit() async {
    final user = _auth.currentUser;
    if (user == null) return;

    QuerySnapshot snapshot = await _firestore
        .collection('rekomendasi')
        .where('favorit', arrayContains: user.uid) // Filter berdasarkan uid
        .get();
    setState(() {
      _favoritList = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorit'),
      ),
      body: ListView.builder(
        itemCount: _favoritList.length,
        itemBuilder: (context, index) {
          var favorit = _favoritList[index];
          return ListTile(
            leading: Image.network(favorit['image']),
            title: Text(favorit['title']),
            subtitle: InkWell(
              onTap: () => _launchURL(favorit['url']),
              child: Text(
                favorit['url'],
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
