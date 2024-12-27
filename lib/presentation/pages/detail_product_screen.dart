import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_inventory/data/models/firebase/produk_model.dart';
import 'package:mobile_inventory/data/models/firebase/transaksi_model.dart';
import 'package:mobile_inventory/presentation/pages/all_product_screen.dart';
import 'package:mobile_inventory/presentation/pages/dashboard_screen.dart';
import 'package:mobile_inventory/presentation/utils/jenis_transaksi.dart';

class DetailproductScreen extends StatefulWidget {
  final String transaksiDocId;
  Produk produk;
  DetailproductScreen(
      {super.key, required this.transaksiDocId, required this.produk});

  @override
  State<DetailproductScreen> createState() => _DetailproductScreenState();
}

class _DetailproductScreenState extends State<DetailproductScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController _namaController = TextEditingController();
  TextEditingController _deskripsiController = TextEditingController();
  TextEditingController _hargaController = TextEditingController();
  TextEditingController _stockController = TextEditingController();
  TextEditingController _gambarController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();

  String? selectedKategoriId;
  String? selectedSupplierId;
  String? selectedProductId;
  String? nama;

  void clearText() {
    _namaController.clear();
    _deskripsiController.clear();
    _hargaController.clear();
    _stockController.clear();
    _gambarController.clear();
    _quantityController.clear();
  }

  Future<List<QueryDocumentSnapshot>> fetchKategori() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('kategori').get();
    return snapshot.docs;
  }

  Future<List<QueryDocumentSnapshot>> fetchSupplier() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('supplier').get();
    return snapshot.docs;
  }

  Future<List<QueryDocumentSnapshot>> fetchProduct() async {
    var snapshot = await FirebaseFirestore.instance.collection('product').get();
    return snapshot.docs;
  }

  Future<void> updateProduct() async {
    var kategoriRef = _firestore.collection('kategori').doc(selectedKategoriId);

    var supplierRef = _firestore.collection('supplier').doc(selectedSupplierId);

    if (_namaController.text.isEmpty ||
        _hargaController.text.isEmpty ||
        _stockController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }

    try {
      await _firestore.collection('produk').doc(widget.transaksiDocId).update({
        'nama': _namaController.text,
        'deskripsi': _deskripsiController.text,
        'harga': int.parse(_hargaController.text),
        'kategori': kategoriRef,
        'stock': int.parse(_stockController.text),
        'gambar': _gambarController.text,
        'supplier': supplierRef,
      });

      DocumentSnapshot updatedData = await _firestore
          .collection('produk')
          .doc(widget.transaksiDocId)
          .get();

      String kategoriNama = "";
      String supplierNama = "";

      if (updatedData['kategori'] is DocumentReference) {
        DocumentSnapshot kategoriDoc =
            await (updatedData['kategori'] as DocumentReference).get();
        kategoriNama = kategoriDoc['nama'] ?? "Tidak Diketahui";
      }

      if (updatedData['supplier'] is DocumentReference) {
        DocumentSnapshot supplierDoc =
            await (updatedData['supplier'] as DocumentReference).get();
        supplierNama = supplierDoc['nama'] ?? "Tidak Diketahui";
      }

      setState(() {
        widget.produk = widget.produk.copyWith(
          nama: updatedData['nama'],
          deskripsi: updatedData['deskripsi'],
          harga: updatedData['harga'],
          kategori: kategoriNama,
          stock: updatedData['stock'],
          gambar: updatedData['gambar'],
          supplier: supplierNama,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil diperbarui')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui produk: $e')),
      );
    }
  }

  Future<void> deleteProduk() async {
    await _firestore.collection('produk').doc(widget.transaksiDocId).delete();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AllproductScreen();
    }));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> searchStream() {
    return _firestore
        .collection('transaksi')
        .where(
          'produk',
          isEqualTo: _firestore.collection('produk').doc(widget.transaksiDocId),
        )
        .snapshots();
  }

  // Future<void> addTransaksi() async {
  //   // Referensi ke produk yang sedang diakses
  //   DocumentReference productRef =
  //       _firestore.collection('produk').doc(widget.transaksiDocId);

  //   try {
  //     await _firestore.collection('transaksi').add({
  //       'uid': _auth.currentUser!.uid,
  //       'nama': nama, // Nama produk
  //       'produk': productRef, // Referensi produk
  //       'quantity': int.parse(_quantityController.text), // Kuantitas
  //       'date': int.parse(_stockController.text), // Tanggal
  //     });

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Transaksi berhasil ditambahkan')),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Gagal menambahkan transaksi: $e')),
  //     );
  //   }
  // }

  Future<void> addTransaksi(int quantity, int tanggal) async {
    // Referensi ke produk yang sedang diakses
    DocumentReference productRef =
        _firestore.collection('produk').doc(widget.transaksiDocId);

    try {
      print("Memulai proses transaksi...");

      // Ambil data produk terkini
      DocumentSnapshot productSnapshot = await productRef.get();
      print("Data produk berhasil diambil: ${productSnapshot.data()}");

      if (!productSnapshot.exists) {
        throw Exception('Produk tidak ditemukan');
      }

      Map<String, dynamic> productData =
          productSnapshot.data() as Map<String, dynamic>;
      int currentStock = productData['stock'] ?? 0;
      print(currentStock);
      // int transactionQuantity = int.parse(_quantityController.text);
      // print(transactionQuantity.toString());

      // Validasi stok
      if (nama == 'Pengeluaran' && quantity > currentStock) {
        throw Exception('Stok tidak mencukupi untuk Pengeluaran');
      }

      // Hitung stok baru
      int newStock = nama == 'Pengeluaran'
          ? currentStock - quantity
          : currentStock + quantity;
      print("Stok baru yang dihitung: $newStock");

      // Tambahkan transaksi ke koleksi transaksi
      await _firestore.collection('transaksi').add({
        'uid': _auth.currentUser!.uid,
        'nama': nama,
        'produk': productRef,
        'quantity': quantity,
        'date': tanggal,
      });
      print("Transaksi berhasil ditambahkan.");

      // Perbarui stok produk
      await productRef.update({'stock': newStock});
      print("Stok produk berhasil diperbarui.");

      setState(() {
        widget.produk = widget.produk.copyWith(
          stock: newStock,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaksi berhasil ditambahkan')),
      );
    } catch (e) {
      print("Kesalahan: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan transaksi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

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
              showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(builder: (context, setStateDialog) {
                      return AlertDialog(
                        title: Text('Update Produk'),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: widget.produk.nama == null
                                    ? _namaController
                                    : _namaController
                                  ..text = widget.produk.nama,
                                decoration: InputDecoration(
                                  hintText: 'Nama',
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: widget.produk.deskripsi == null
                                    ? _deskripsiController
                                    : _deskripsiController
                                  ..text = widget.produk.deskripsi,
                                decoration: InputDecoration(
                                  hintText: 'deskripsi',
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: widget.produk.harga == null
                                    ? _hargaController
                                    : _hargaController
                                  ..text = widget.produk.harga.toString(),
                                decoration: InputDecoration(
                                  hintText: 'harga',
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Dropdown kategori
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
                                controller: widget.produk.stock == null
                                    ? _stockController
                                    : _stockController
                                  ..text = widget.produk.stock.toString(),
                                decoration: InputDecoration(
                                  hintText: 'stock',
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: widget.produk.gambar == null
                                    ? _gambarController
                                    : _gambarController
                                  ..text = widget.produk.gambar,
                                decoration: InputDecoration(
                                  hintText: 'Gambar',
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
                              updateProduct();
                              clearText();
                              Navigator.pop(context);
                            },
                            child: const Text("Simpan"),
                          ),
                        ],
                      );
                    });
                  });
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              deleteProduk();
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
                child: Image.network(widget.produk.gambar),
              ),
              Divider(
                color: Colors.grey,
                thickness: 5,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(0, 4),
                      blurRadius: 10,
                      spreadRadius: 2,
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
                      Text(
                          "Harga Product  : ${widget.produk.harga.toString()}"),
                      SizedBox(
                        height: 16,
                      ),
                      Text("Kategori Product : ${widget.produk.kategori}"),
                      SizedBox(
                        height: 16,
                      ),
                      Text("Deskripsi Product : ${widget.produk.deskripsi}"),
                      SizedBox(
                        height: 16,
                      ),
                      Text("Nama Product : ${widget.produk.nama}"),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                          "Stock Product  : ${widget.produk.stock.toString()}"),
                      SizedBox(
                        height: 16,
                      ),
                      Text("supplier Product  : ${widget.produk.supplier}"),
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
                  color: Colors.white,
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
                                // _getAllTransactionsByProductId(product.id!);
                                // print(product.id!);
                              },
                              child: Text("Riwayat"))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      //tampilkan data
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          height: 200, // Memberikan batasan tinggi
                          child: StreamBuilder<
                              QuerySnapshot<Map<String, dynamic>>>(
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

                              // Menyimpan data transaksi
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

                                  final DocumentReference? transaksiRef =
                                      data['produk'];

                                  print("data product e ${data['produk']}");

                                  return FutureBuilder<
                                      DocumentSnapshot<Map<String, dynamic>>>(
                                    future: (transaksiRef as DocumentReference<
                                            Map<String, dynamic>>)
                                        .get(),
                                    builder: (context, transaksiSnapshot) {
                                      if (transaksiSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }

                                      if (transaksiSnapshot.hasError) {
                                        return Center(
                                            child:
                                                Text("Error memuat kategori"));
                                      }

                                      if (!transaksiSnapshot.hasData ||
                                          transaksiSnapshot.data!.data() ==
                                              null) {
                                        return Center(
                                            child: Text(
                                                "Kategori tidak ditemukan"));
                                      }

                                      final transaksiData =
                                          transaksiSnapshot.data!.data()
                                              as Map<String, dynamic>;
                                      final String productName =
                                          transaksiData['nama'] ??
                                              "Nama tidak tersedia";

                                      listTransaksi.add(Transaksi(
                                        uid: uid,
                                        nama: nama,
                                        productName: productName,
                                        quantity: quantity,
                                        date: date,
                                      ));

                                      return ListTile(
                                        title: Center(child: Text(nama)),
                                        subtitle: Column(
                                          children: [
                                            Text("Produk: $productName"),
                                            Text("Quantity: $quantity"),
                                            Text("Date: $date"),
                                          ],
                                        ),
                                        trailing: IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.remove),
                                        ),
                                      );
                                    },
                                  );
                                },
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
          showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(builder: (context, setStateDialog) {
                  return AlertDialog(
                    title: Text('Tambah transaksi'),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownButton<String>(
                            items: dataTransaksi
                                .map((e) => DropdownMenuItem<String>(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setStateDialog(() {
                                nama = value;
                              });
                            },
                            hint: Text("Pilih jenis transaksi"),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            keyboardType: TextInputType.numberWithOptions(),
                            controller: _quantityController,
                            decoration: InputDecoration(
                              hintText: 'quantity',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            keyboardType: TextInputType.numberWithOptions(),
                            controller: _stockController,
                            decoration: InputDecoration(
                              hintText: 'date',
                            ),
                          ),
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
                          addTransaksi(int.parse(_quantityController.text),
                              int.parse(_stockController.text));
                          clearText();
                          Navigator.pop(context);
                        },
                        child: const Text("Simpan"),
                      ),
                    ],
                  );
                });
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
