import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_inventory/data/helpers/dbhelper.dart';
import 'package:mobile_inventory/data/models/sqflite/product_transaction_model.dart';
import 'package:mobile_inventory/presentation/utils/date_format.dart';

class AllhistoryproductScreen extends StatefulWidget {
  const AllhistoryproductScreen({super.key});

  @override
  State<AllhistoryproductScreen> createState() =>
      _AllhistoryproductScreenState();
}

class _AllhistoryproductScreenState extends State<AllhistoryproductScreen> {
  List<Producttransaction> listTransactions = [];
  Dbhelper db = Dbhelper();

  Future<void> _getAllTransactions() async {
    var list = await db.getAllProdukWithTransaction();

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

  Future<void> deleteTransaction(int id, String name) async {
    final db = Dbhelper();

    try {
      print("id mu $id");
      await db.deleteTransaction(id);

      setState(() {
        listTransactions.removeWhere((transaction) => transaction.getId == id);
      });

      _getAllTransactions();

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

  @override
  void initState() {
    _getAllTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return listTransactions.isEmpty
        ? Scaffold(
            body: Center(
              child: Text("history kosong"),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Daftar Riwayat Transaksi"),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: listTransactions.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          leading: Container(
                            width: 90,
                            height: 90,
                            child: Image.memory(
                              Base64Decoder().convert(
                                  listTransactions[index].getProductGambar),
                              fit: BoxFit.cover, // Mengisi sepenuhnya lingkaran
                            ),
                          ),
                          title: Center(
                            child: Text(listTransactions[index].getProductType),
                          ),
                          subtitle: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    listTransactions[index].getProductName,
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
                                    listTransactions[index].getProductDate),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              deleteTransaction(listTransactions[index].getId,
                                  listTransactions[index].getProductName);

                              print(listTransactions[index].getId);
                            },
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
            ),
          );
  }
}
