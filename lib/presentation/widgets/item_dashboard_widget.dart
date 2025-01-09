import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_inventory/data/models/firebase/produk_model.dart';
import 'package:mobile_inventory/data/models/sqflite/product_categories_model.dart';
import 'package:mobile_inventory/presentation/pages/detail_product_screen.dart';

class ItemdashboardWidget extends StatefulWidget {
  final String transaksiDocId;
  final Produk produk;
  const ItemdashboardWidget({
    super.key,
    required this.transaksiDocId,
    required this.produk,
  });

  @override
  State<ItemdashboardWidget> createState() => _ItemdashboardWidgetState();
}

class _ItemdashboardWidgetState extends State<ItemdashboardWidget> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    CollectionReference produkCollection = _firestore.collection('produk');
    TextEditingController _namaController = TextEditingController();
    TextEditingController _deskripsiController = TextEditingController();
    TextEditingController _hargaController = TextEditingController();
    TextEditingController _kategoriController = TextEditingController();
    TextEditingController _stockController = TextEditingController();
    TextEditingController _gambarController = TextEditingController();

    print("kategori ${widget.produk.kategori}");
    return Stack(
      children: [
        Positioned(
          bottom: -2,
          right: -2,
          left: -2,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DetailproductScreen(
                    transaksiDocId: widget.transaksiDocId,
                    produk: widget.produk);
              }));
            },
            child: Container(
              width: 200,
              height: 200,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    widget.produk.nama,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        fontSize: 20),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              widget.produk.kategori,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              'Rp ${widget.produk.harga.toString()}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                          ],
                        ),
                        VerticalDivider(
                          color: Colors.red,
                          thickness: 2,
                          width: 5,
                        ),
                        Column(
                          children: [
                            Text("Stok"),
                            Text(
                              widget.produk.stock.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
            left: 20,
            child: Container(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      widget.produk.gambar,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ))
      ],
    );
  }
}
