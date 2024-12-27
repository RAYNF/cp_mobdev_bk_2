import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_inventory/data/models/firebase/supplier_model.dart';
import 'package:mobile_inventory/presentation/pages/dashboard_screen.dart';
import 'package:mobile_inventory/presentation/pages/detail_suplier_screen.dart';

class AllSuplierScreen extends StatefulWidget {
  const AllSuplierScreen({super.key});

  @override
  State<AllSuplierScreen> createState() => _AllSuplierScreenState();
}

class _AllSuplierScreenState extends State<AllSuplierScreen> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    FirebaseAuth _auth = FirebaseAuth.instance;

    CollectionReference supplierCollection = _firestore.collection('supplier');
    final User? user = _auth.currentUser;

    TextEditingController _namaController = TextEditingController();
    TextEditingController _alamatController = TextEditingController();
    TextEditingController _kontakController = TextEditingController();
    TextEditingController _latitudeController = TextEditingController();
    TextEditingController _longtitudeController = TextEditingController();
    TextEditingController _searchController = TextEditingController();

    bool isComplete = false;

    Future<void> deleteSupplier(String transaksiDocId) async {
      await _firestore.collection('supplier').doc(transaksiDocId).delete();
    }

    Future<void> updateSupplier(String transaksiDocId) async {
      await _firestore.collection('supplier').doc(transaksiDocId).update({
        'nama': _namaController.text,
        'alamat': _alamatController.text,
        'kontak': _kontakController.text,
        'latitude': _latitudeController.text,
        'longtitude': _longtitudeController.text,
      });
    }

    Stream<QuerySnapshot<Map<String, dynamic>>> searchStream() {
      return _firestore.collection('supplier').snapshots();
    }

    void clearText() {
      _namaController.clear();
      _alamatController.clear();
      _kontakController.clear();
      _latitudeController.clear();
      _longtitudeController.clear();
    }

    Future<void> addSupplier() {
      return supplierCollection.add({
        'uid': _auth.currentUser!.uid,
        'nama': _namaController.text,
        'alamat': _alamatController.text,
        'kontak': _kontakController.text,
        'latitude': _latitudeController.text,
        'longtitude': _longtitudeController.text,
      }).catchError((error) => print("failed to add product: $error"));
    }

    Future<Position> getCurrentLocation() async {
      bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        return Future.error('Location Service are disabbled');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error("Location permission are denied");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            "Location Permission are permanentky denied, wa can not request permision");
      }

      return await Geolocator.getCurrentPosition();
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () {
          // Navigator.pushNamed(context, '/addproduct');
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Tambah Supplier'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _namaController,
                      decoration: const InputDecoration(
                        labelText: "Nama Supplier",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _alamatController,
                      decoration: const InputDecoration(
                        labelText: "alamat Supplier",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _kontakController,
                      decoration: const InputDecoration(
                        labelText: "kontak Supplier",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _longtitudeController,
                      decoration: const InputDecoration(
                        labelText: "longtitude Supplier",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _latitudeController,
                      decoration: const InputDecoration(
                        labelText: "latitude Supplier",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container()
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Batal")),
                TextButton(
                    onPressed: () {
                      addSupplier();
                      clearText();
                      Navigator.pop(context);
                    },
                    child: const Text("Simpan"))
              ],
            ),
          );
        },
      ),
      appBar: AppBar(
        title: Text("Daftar Supplier"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return DashboardScreen();
            }));
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: EdgeInsets.symmetric(
          //     vertical: 15,
          //     horizontal: 10,
          //   ),
          //   child: TextField(
          //     decoration: InputDecoration(
          //       labelText: "Search",
          //       prefixIcon: Icon(
          //         Icons.search,
          //       ),
          //       border: OutlineInputBorder(),
          //     ),
          //     onChanged: (textEntered) {
          //       searchStream(textEntered);

          //       setState(() {
          //         _searchController.text = textEntered;
          //       });
          //     },
          //   ),
          // ),
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: searchStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text("Tidak ada ditemukan"),
                      );
                    }

                    List<Suplier> listProduk =
                        snapshot.data!.docs.map((document) {
                      final data = document.data();
                      final String nama = data['nama'];
                      final String alamat = data['alamat'];
                      final String kontak = data['kontak'];
                      final String latitude = data['latitude'];
                      final String longtitude = data['longtitude'];
                      final String uid = user!.uid;

                      return Suplier(
                          uid: uid,
                          nama: nama,
                          alamat: alamat,
                          kontak: kontak,
                          latitude: latitude,
                          longtitude: longtitude);
                    }).toList();
                    // return ListView.builder(
                    //     shrinkWrap: true,
                    //     itemCount: listProduk.length,
                    //     itemBuilder: (context, index) {
                    //       return ItemdashboardWidget(
                    //           transaksiDocId: snapshot.data!.docs[index].id,
                    //           produk: listProduk[index]);
                    //     });

                    return ListView.builder(
                        itemCount: listProduk.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Update supplier'),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller:
                                                  listProduk[index].nama == ""
                                                      ? _namaController
                                                      : _namaController
                                                    ..text =
                                                        listProduk[index].nama,
                                              decoration: InputDecoration(
                                                hintText: 'Nama',
                                              ),
                                            ),
                                            TextField(
                                              controller:
                                                  listProduk[index].alamat == ""
                                                      ? _alamatController
                                                      : _alamatController
                                                    ..text = listProduk[index]
                                                        .alamat,
                                              decoration: InputDecoration(
                                                hintText: 'Alamat',
                                              ),
                                            ),
                                            TextField(
                                              controller:
                                                  listProduk[index].kontak == ""
                                                      ? _kontakController
                                                      : _kontakController
                                                    ..text = listProduk[index]
                                                        .kontak
                                                        .toString(),
                                              decoration: InputDecoration(
                                                hintText: 'Kontak',
                                              ),
                                            ),
                                            TextField(
                                              controller: listProduk[index]
                                                          .latitude ==
                                                      ""
                                                  ? _latitudeController
                                                  : _latitudeController
                                                ..text =
                                                    listProduk[index].latitude,
                                              decoration: InputDecoration(
                                                hintText: 'Latitude',
                                              ),
                                            ),
                                            TextField(
                                              controller: listProduk[index]
                                                          .longtitude ==
                                                      ""
                                                  ? _longtitudeController
                                                  : _longtitudeController
                                                ..text = listProduk[index]
                                                    .longtitude
                                                    .toString(),
                                              decoration: InputDecoration(
                                                hintText: 'Longtitude',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Batalkan'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            updateSupplier(
                                                snapshot.data!.docs[index].id);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Update'),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                icon: Icon(Icons.edit)),
                            title: Text(
                              listProduk[index].nama,
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Column(
                              children: [
                                Text(
                                  listProduk[index].alamat,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  listProduk[index].kontak.toString(),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  deleteSupplier(snapshot.data!.docs[index].id);
                                },
                                icon: Icon(Icons.remove)),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return DetailSuplierScreen(
                                  suplier: listProduk[index],
                                );
                              }));
                            },
                          );
                        });
                  }))
        ],
      ),
    );
  }
}
