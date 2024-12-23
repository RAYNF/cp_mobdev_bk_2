import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_inventory/data/models/sqflite/product_categories_model.dart';

class ItemdashboardWidget extends StatefulWidget {
  final ProductWithCategory barang;
  const ItemdashboardWidget({
    super.key,
    required this.barang,
  });

  @override
  State<ItemdashboardWidget> createState() => _ItemdashboardWidgetState();
}

class _ItemdashboardWidgetState extends State<ItemdashboardWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: -2,
          right: -2,
          left: -2,
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/detail', arguments: widget.barang);
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
                    widget.barang.nama!,
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
                              widget.barang.kategoriName.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              'Rp ${widget.barang.harga.toString()}',
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
                              widget.barang.stock.toString(),
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
                    child: Image.memory(
                      Base64Decoder().convert(widget.barang.gambar!),
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
