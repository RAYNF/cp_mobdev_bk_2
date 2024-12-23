import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_inventory/data/models/firebase/akun_model.dart';
import 'package:mobile_inventory/presentation/pages/dashboard/all_kategori_screen.dart';
import 'package:mobile_inventory/presentation/pages/dashboard/all_history_product_screen.dart';
import 'package:mobile_inventory/presentation/pages/dashboard/all_product_screen.dart';
import 'package:mobile_inventory/presentation/pages/dashboard/profil_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const routeName = '/dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool _isLoading = false;
  List<Widget> pages = [];

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Akun akun = Akun(
    uid: '',
    docId: '',
    nama: '',
    noHp: '',
    email: '',
    role: '',
  );

  void getAkun() async {
    setState(() {
      _isLoading = false;
    });
    print("dashbard : ${_auth.currentUser!.uid}");
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('akun')
          .where('uid', isEqualTo: _auth.currentUser!.uid)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;

        setState(() {
          akun = Akun(
              uid: userData['uid'],
              docId: userData['docId'],
              nama: userData['nama'],
              noHp: userData['noHP'],
              email: userData['email'],
              role: userData['role']);
        });
      }
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    getAkun();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pages = <Widget>[
      AllproductScreen(),
      AllkategoriScreen(),
      AllhistoryproductScreen(),
      ProfilScreen(
        akun: akun,
      )
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueAccent,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        selectedFontSize: 16,
        unselectedItemColor: Colors.green[800],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.space_dashboard_outlined),
            label: "Semua",
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.book,
              ),
              label: "Riwayat"),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.category_outlined,
            ),
            label: "Category",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.info,
            ),
            label: "User",
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : pages.elementAt(_selectedIndex),
    );
  }
}
