import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_inventory/data/helpers/dbhelper.dart';
import 'package:mobile_inventory/data/models/sqflite/product_models.dart';
import 'package:mobile_inventory/data/models/sqflite/product_categories_model.dart';
import 'package:mobile_inventory/presentation/widgets/item_dashboard_widget.dart';

class AllproductScreen extends StatefulWidget {
  const AllproductScreen({super.key});

  @override
  State<AllproductScreen> createState() => _AllproductScreenState();
}

class _AllproductScreenState extends State<AllproductScreen> {
  List<ProductWithCategory> listProduct = [];

  Dbhelper db = Dbhelper();

  Future<void> _getAllProduct() async {
    var list = await db.getAllProdukWithKategoriName();

    setState(() {
      listProduct = list;
    });
  }

  @override
  void initState() {
    _getAllProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/addproduct');
        },
      ),
      appBar: AppBar(
        title: Text("Daftar Barang"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(16),
        child: GridView.builder(
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 250,
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: listProduct.length,
            itemBuilder: (context, index) {
              return ItemdashboardWidget(
                barang: listProduct[index],
              );
            }),
      )),
    );
  }
}
