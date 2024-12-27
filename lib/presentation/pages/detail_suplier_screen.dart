// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:mobile_inventory/data/models/firebase/supplier_model.dart';

class DetailSuplierScreen extends StatelessWidget {
  Suplier suplier;
  DetailSuplierScreen({
    Key? key,
    required this.suplier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Suplier"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              children: [
                Text(suplier.nama),
                SizedBox(
                  height: 10,
                ),
                Text(suplier.alamat),
                SizedBox(
                  height: 10,
                ),
                Text(suplier.kontak),
                SizedBox(
                  height: 10,
                ),
                Text(suplier.latitude),
                SizedBox(
                  height: 10,
                ),
                Text(suplier.longtitude),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
