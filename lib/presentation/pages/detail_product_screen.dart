import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_inventory/data/helpers/dbhelper.dart';
import 'package:mobile_inventory/data/models/sqflite/product_categories_model.dart';
import 'package:mobile_inventory/data/models/sqflite/product_transaction_model.dart';
import 'package:mobile_inventory/presentation/pages/add_product_screen.dart';
import 'package:mobile_inventory/presentation/pages/add_transaction_screen.dart';
import 'package:mobile_inventory/presentation/pages/dashboard_screen.dart';
import 'package:mobile_inventory/presentation/utils/date_format.dart';

class DetailproductScreen extends StatefulWidget {
  const DetailproductScreen({super.key});

  static const routeName = '/detail';

  @override
  State<DetailproductScreen> createState() => _DetailproductScreenState();
}

class _DetailproductScreenState extends State<DetailproductScreen> {
  final db = Dbhelper();
  List<Producttransaction> listTransactions = [];

  Future<void> _getAllTransactionsByProductId(int productId) async {
    var list = await db.getTransactionProductById(productId);

    if (list.isNotEmpty) {
      setState(() {
        listTransactions = list.reversed.toList();
      });
    } else {
      setState(() {
        listTransactions = [];
      });
    }
  }

  Future<void> deleteTransaction(int id, String name, int productId) async {
    final db = Dbhelper();

    try {
      print("id mu $id");
      await db.deleteTransaction(id);

      setState(() {
        listTransactions.removeWhere((transaction) => transaction.getId == id);
      });

      _getAllTransactionsByProductId(productId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${name} delete succes"),
        ),
      );
      // Navigator.pushNamed(context, '/dashboard');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete ${name} because $e"),
        ),
      );
    }
  }

  Future<void> deleteProduct(int id, String name) async {
    try {
      await db.deleteProduct(id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${name} delete succes"),
        ),
      );

      Navigator.pushNamed(context, '/dashboard');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete ${name} because $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final product =
        ModalRoute.of(context)?.settings.arguments as ProductWithCategory;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Barang"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DashboardScreen();
                },
              ),
            );
          },
          icon: Icon(Icons.arrow_back_ios_new_sharp),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final db = Dbhelper();
              try {
                final productData = await db.getProductById(product.id!);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AddproductScreen(
                        produk: productData,
                      );
                    },
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Gagal Ambil data product : $e"),
                  ),
                );
              }
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              deleteProduct(product.id!, product.nama!);
            },
            icon: const Icon(Icons.remove),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 250,
                child: Image.memory(
                  Base64Decoder().convert(product.gambar!),
                  fit: BoxFit.fill,
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: 5,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors
                      .white, // Anda bisa mengganti warna sesuai kebutuhan
                  borderRadius:
                      BorderRadius.circular(10), // Jika ingin sudut melengkung
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.1), // Warna bayangan dengan opasitas
                      offset: Offset(
                          0, 4), // Posisi bayangan (horizontal, vertical)
                      blurRadius: 10, // Membuat bayangan lebih lembut
                      spreadRadius:
                          2, // Menentukan seberapa besar bayangan menyebar
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text("Harga Product  : ${product.harga.toString()}"),
                      SizedBox(
                        height: 16,
                      ),
                      Text("Kategori Product : ${product.kategoriName!}"),
                      SizedBox(
                        height: 16,
                      ),
                      Text("Deskripsi Product : ${product.deskripsi!}"),
                      SizedBox(
                        height: 16,
                      ),
                      Text("Nama Product : ${product.nama!}"),
                      SizedBox(
                        height: 16,
                      ),
                      Text("Stock Product  : ${product.stock.toString()}"),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors
                      .white, // Anda bisa mengganti warna sesuai kebutuhan
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("History Product"),
                          ElevatedButton(
                              onPressed: () {
                                _getAllTransactionsByProductId(product.id!);
                                print(product.id!);
                              },
                              child: Text("Riwayat"))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          height: 300,
                          child: listTransactions.isEmpty
                              ? Center(
                                  child: Text("Data belum tampil"),
                                )
                              : ListView.builder(
                                  itemCount: listTransactions.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        ListTile(
                                          title: Center(
                                            child: Text(listTransactions[index]
                                                .getProductType),
                                          ),
                                          subtitle: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    listTransactions[index]
                                                        .getProductName,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    listTransactions[index]
                                                        .getProductQuantity
                                                        .toString(),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                formatDate(
                                                    listTransactions[index]
                                                        .getProductDate),
                                              ),
                                            ],
                                          ),
                                          trailing: IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.remove),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    );
                                  },
                                ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final db = Dbhelper();

          final productData = await db.getProductById(product.id!);

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddtransactionScreen(product: productData);
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
