import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_inventory/data/models/firebase/transaksi_model.dart';
import 'package:mobile_inventory/presentation/utils/date_format.dart';

class AllhistoryproductScreen extends StatefulWidget {
  const AllhistoryproductScreen({super.key});

  @override
  State<AllhistoryproductScreen> createState() =>
      _AllhistoryproductScreenState();
}

class _AllhistoryproductScreenState extends State<AllhistoryproductScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isComplete = false;

  Stream<QuerySnapshot<Map<String, dynamic>>> searchStream() {
    return _firestore.collection("transaksi").snapshots();
  }

  Future<void> deleteTransaksi(String docIdTransaksi) async {
    await _firestore.collection('transaksi').doc(docIdTransaksi).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Riwayat Transaksi'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: searchStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("Tidak ada data"),
            );
          }

          List<Transaksi> listTransaksi = [];

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final document = snapshot.data!.docs[index];
              final data = document.data();

              final String nama = data['nama'];
              final int quantity = data['quantity'];
              final int date = data['date'];
              final String uid = data['uid'];

              final DocumentReference? transaksiRef = data['produk'];

              print("data product e ${data['produk']}");

              return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future:
                    (transaksiRef as DocumentReference<Map<String, dynamic>>)
                        .get(),
                builder: (context, transaksiSnapshot) {
                  if (transaksiSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final produkTransaksiData = transaksiSnapshot.data?.data();
                  final produkNama = produkTransaksiData == null
                      ? "produk tidak ada"
                      : (produkTransaksiData as Map<String, dynamic>)['nama'];

                  listTransaksi.add(Transaksi(
                    uid: uid,
                    nama: nama,
                    productName: produkNama,
                    quantity: quantity,
                    date: date,
                  ));

                  return ListTile(
                    title: Center(child: Text(nama)),
                    subtitle: Column(
                      children: [
                        Text("Produk: $produkNama"),
                        Text("Quantity:$quantity"),
                        Text("Date: ${formatDate(date)}"),
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        deleteTransaksi(snapshot.data!.docs[index].id);
                      },
                      icon: Icon(Icons.remove),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
