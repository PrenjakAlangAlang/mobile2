import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile2/Menu/daftaranggota.dart';
import 'package:mobile2/Menu/favorit.dart';
import 'package:mobile2/Menu/rekomendasi.dart';
import 'package:mobile2/Menu/stopwatch.dart';
import 'package:mobile2/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: _selectedIndex == 0 ? _buildHomeContent() : _buildHelpContent(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'Bantuan',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildHomeContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: <Widget>[
                _menuCard(Icons.person, 'Daftar Anggota', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DaftarAnggota()),
                  );
                }),
                _menuCard(Icons.access_time, 'Aplikasi Stopwatch', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Stopwatch()),
                  );
                }),
                _menuCard(Icons.web, 'Daftar Rekomendasi', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DaftarRekomendasi()),
                  );
                }),
                _menuCard(Icons.favorite, 'Favorite', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Favorit()),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Penggunaan Aplikasi', style: TextStyle(fontSize: 20)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _menuCard(IconData icon, String title, VoidCallback onPressed) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
