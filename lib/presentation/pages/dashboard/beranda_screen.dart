import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_inventory/presentation/pages/all_product_screen.dart';
import 'package:mobile_inventory/presentation/pages/all_kategori_screen.dart';
import 'package:mobile_inventory/presentation/pages/all_suplier_screen.dart';
import 'package:mobile_inventory/presentation/utils/styles.dart';
import 'package:mobile_inventory/presentation/widgets/item_beranda_widget.dart';

class BerandaScreen extends StatelessWidget {
  const BerandaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    bool isComplate = false;

    Future<int> getTotalProduct() async {
      final snapshot = await _firestore.collection('produk').get();
      return snapshot.size;
    }

    Future<int> getTotalKategori() async {
      final snapshot = await _firestore.collection('kategori').get();
      return snapshot.size;
    }

    Future<int> getTotalSupplier() async {
      final snapshot = await _firestore.collection('supplier').get();
      return snapshot.size;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Halaman Beranda"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              ItemBeranda(
                imagePath: 'assets/images/episode1.jpg',
                fetchTotalProducts: getTotalProduct,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AllproductScreen();
                  }));
                },
                title: 'Total product',
              ),
              SizedBox(
                height: 20,
              ),
              ItemBeranda(
                imagePath: 'assets/images/episode1.jpg',
                fetchTotalProducts: getTotalKategori,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AllkategoriScreen();
                  }));
                },
                title: 'Total kategori',
              ),
              SizedBox(
                height: 20,
              ),
              ItemBeranda(
                imagePath: 'assets/images/episode1.jpg',
                fetchTotalProducts: getTotalSupplier,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AllSuplierScreen();
                  }));
                },
                title: 'Total suplier',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
