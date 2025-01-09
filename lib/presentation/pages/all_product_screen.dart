import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_inventory/data/models/firebase/produk_model.dart';
import 'package:mobile_inventory/presentation/pages/dashboard_screen.dart';
import 'package:mobile_inventory/presentation/widgets/item_dashboard_widget.dart';

class AllproductScreen extends StatefulWidget {
  const AllproductScreen({super.key});

  @override
  State<AllproductScreen> createState() => _AllproductScreenState();
}

class _AllproductScreenState extends State<AllproductScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _namaController = TextEditingController();
  TextEditingController _deskripsiController = TextEditingController();
  TextEditingController _hargaController = TextEditingController();
  TextEditingController _stockController = TextEditingController();
  TextEditingController _gambarController = TextEditingController();
  TextEditingController _searchController = TextEditingController();

  bool isComplete = false;
  String? selectedKategoriId;
  String? selectedSupplierId;

  Stream<QuerySnapshot<Map<String, dynamic>>> searchStream(String textEntered) {
    if (textEntered.isEmpty) {
      return _firestore.collection('produk').snapshots();
    } else {
      return _firestore
          .collection('produk')
          .where('nama', isEqualTo: textEntered)
          .snapshots();
    }
  }

  void clearText() {
    _namaController.clear();
    _deskripsiController.clear();
    _hargaController.clear();
    _stockController.clear();
    _gambarController.clear();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    var colref = _firestore.collection('produk');

    Future<void> addProduct() {
      if (selectedKategoriId == null) {
        print("Pilih kategori terlebih dahulu");
        return Future.error("Kategori tidak dipilih");
      }

      if (selectedSupplierId == null) {
        print("Pilih Supplier terlebih dahulu");
        return Future.error("Supplier tidak dipilih");
      }

      var kategoriRef =
          _firestore.collection('kategori').doc(selectedKategoriId);

      var supplierRef =
          _firestore.collection('supplier').doc(selectedSupplierId);

      return colref.add({
        'uid': _auth.currentUser!.uid,
        'nama': _namaController.text,
        'deskripsi': _deskripsiController.text,
        'harga': int.parse(_hargaController.text),
        'kategori': kategoriRef,
        'stock': int.parse(_stockController.text),
        'gambar': _gambarController.text,
        'supplier': supplierRef
      }).catchError((error) => print("failed to add product: $error"));
    }

    Future<List<QueryDocumentSnapshot>> fetchKategori() async {
      var querySnapshot = await _firestore.collection('kategori').get();
      return querySnapshot.docs;
    }

    Future<List<QueryDocumentSnapshot>> fetchSupplier() async {
      var querySnapshot = await _firestore.collection('supplier').get();
      return querySnapshot.docs;
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setStateDialog) {
                  return AlertDialog(
                    title: Text('Tambah Produk'),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _namaController,
                            decoration: const InputDecoration(
                              labelText: "Nama Produk",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _deskripsiController,
                            decoration: const InputDecoration(
                              labelText: "Deskripsi Produk",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _hargaController,
                            decoration: const InputDecoration(
                              labelText: "Harga Produk",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          FutureBuilder<List<QueryDocumentSnapshot>>(
                            future: fetchKategori(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }

                              if (snapshot.hasError || !snapshot.hasData) {
                                return Text("Gagal memuat kategori");
                              }

                              return DropdownButton<String>(
                                value: selectedKategoriId,
                                items: snapshot.data!
                                    .map((doc) => DropdownMenuItem<String>(
                                          value: doc.id,
                                          child: Text(doc['nama']),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setStateDialog(() {
                                    selectedKategoriId = value!;
                                  });
                                },
                                hint: Text("Pilih Kategori"),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _stockController,
                            decoration: const InputDecoration(
                              labelText: "Stock Produk",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _gambarController,
                            decoration: const InputDecoration(
                              labelText: "Gambar Produk",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          FutureBuilder<List<QueryDocumentSnapshot>>(
                            future: fetchSupplier(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }

                              if (snapshot.hasError || !snapshot.hasData) {
                                return Text("Gagal memuat kategori");
                              }

                              return DropdownButton<String>(
                                value: selectedSupplierId,
                                items: snapshot.data!
                                    .map((doc) => DropdownMenuItem<String>(
                                          value: doc.id,
                                          child: Text(doc['nama']),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setStateDialog(() {
                                    selectedSupplierId = value!;
                                  });
                                },
                                hint: Text("Pilih Supplier"),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Batal"),
                      ),
                      TextButton(
                        onPressed: () {
                          addProduct();
                          clearText();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return AllproductScreen();
                          }));
                        },
                        child: const Text("Simpan"),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
      appBar: AppBar(
        title: Text("Daftar Barang"),
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
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 10,
            ),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Search",
                prefixIcon: Icon(
                  Icons.search,
                ),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (textEntered) {
                searchStream(textEntered);

                setState(() {
                  _searchController.text = textEntered;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: searchStream(_searchController.text),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("Tidak ada data ditemukan"));
                }

                List<Produk> listProduk = [];

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final document = snapshot.data!.docs[index];
                    final data = document.data();
                    final kategoriRef = data['kategori'] as DocumentReference;
                    final supplierRef = data['supplier'] as DocumentReference;

                    return FutureBuilder<DocumentSnapshot>(
                      future: kategoriRef.get(),
                      builder: (context, kategoriSnapshot) {
                        if (kategoriSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final kategoriData = kategoriSnapshot.data?.data();
                        final kategoriNama = kategoriData == null
                            ? "Kategori tidak ada"
                            : (kategoriData as Map<String, dynamic>)['nama'];

                        return FutureBuilder<DocumentSnapshot>(
                          future: supplierRef.get(),
                          builder: (context, supplierSnapshot) {
                            if (supplierSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            final supplierData = supplierSnapshot.data?.data();
                            final supplierNama = supplierData == null
                                ? "Supplier tidak ada"
                                : (supplierData
                                    as Map<String, dynamic>)['nama'];

                            final produk = Produk(
                              uid: data['uid'],
                              nama: data['nama'],
                              deskripsi: data['deskripsi'],
                              harga: data['harga'],
                              kategori: kategoriNama,
                              stock: data['stock'],
                              gambar: data['gambar'],
                              supplier: supplierNama,
                            );
                            listProduk.add(produk);

                            if (index == snapshot.data!.docs.length - 1) {
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 250,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                ),
                                itemCount: listProduk.length,
                                itemBuilder: (context, gridIndex) {
                                  return ItemdashboardWidget(
                                    transaksiDocId:
                                        snapshot.data!.docs[gridIndex].id,
                                    produk: listProduk[gridIndex],
                                  );
                                },
                              );
                            }
                            return SizedBox.shrink();
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
