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
  // final ProductWithCategory barang;
  final String transaksiDocId;
  final Produk produk;
  const ItemdashboardWidget({
    super.key,
    required this.transaksiDocId,
    required this.produk,
    // required this.barang,
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

    // final ImagePicker imgpicker = ImagePicker();
    // final String defaultImage = 'assets/images/episode1.jpg';
    // String imagepath = "";
    // String imageBase64 = "";

    // Future<void> deleteProduk() async {
    //   await _firestore.collection('produk').doc(widget.transaksiDocId).delete();
    // }

    // Future<void> updateProduct() async {
    //   await _firestore.collection('produk').doc(widget.transaksiDocId).update({
    //     'nama': _namaController.text,
    //     'deskripsi': _deskripsiController.text,
    //     'harga': int.parse(_hargaController.text),
    //     'kategori': _kategoriController.text,
    //     'stock': int.parse(_stockController.text),
    //     'gambar': _gambarController.text
    //   });
    // }

    // Future<String> getKategoriNama(String kategoriRef) async {
    //   try {
    //     DocumentSnapshot kategoriSnapshot =
    //         await FirebaseFirestore.instance.doc(kategoriRef).get();
    //     return kategoriSnapshot['nama'] ?? "Kategori tidak ditemukan";
    //   } catch (e) {
    //     return "Kategori Tidak Diketahui";
    //   }
    // }

    print("kategori ${widget.produk.kategori}");
    // Future<void> openImage(ImageSource sources) async {
    //   try {
    //     final pickedFile = await imgpicker.pickImage(source: sources);

    //     if (pickedFile != null) {
    //       imagepath = pickedFile.path;

    //       File imageFile = File(imagepath);
    //       Uint8List imagebytes = await imageFile.readAsBytes();
    //       String base64string = base64.encode(imagebytes);

    //       setState(() {
    //         imageBase64 = base64string;
    //       });
    //     }
    //   } catch (e) {
    //     print("error whiling picking file");
    //   }
    // }

    // Future<void> upsertProduct() async {
    //   if (widget.produk != null) {
    //     final updatedProduct = Product.fromMap({
    //       'id': widget.produk!.getId,
    //       'nama': nama!.text,
    //       'deskripsi': deskripsi!.text,
    //       'harga': int.parse(harga!.text),
    //       // 'kategori': int.parse(kategori!.text),
    //       'kategori': selectedKategoriId!,
    //       'stock': int.parse(stock!.text),
    //       'gambar': imageBase64,
    //     });

    //     await db.updateProduct(updatedProduct);

    //     final productData =
    //         await db.getProductWithCategoryById(updatedProduct.getId);

    //     Navigator.pushReplacementNamed(context, '/detail',
    //         arguments: productData);
    //   } else {
    //     await db.saveProduct(
    //       Product(
    //         nama!.text,
    //         deskripsi!.text,
    //         int.parse(harga!.text),
    //         selectedKategoriId!,
    //         int.parse(stock!.text),
    //         imageBase64.isNotEmpty
    //             ? imageBase64
    //             : base64.encode(
    //                 await loadDefaultImageBytes(),
    //               ),
    //       ),
    //     );
    //     Navigator.pushReplacementNamed(context, '/dashboard');
    //   }
    // }

    // Future<Uint8List> loadDefaultImageBytes() async {
    //   ByteData bytes = await DefaultAssetBundle.of(context).load(defaultImage);
    //   return bytes.buffer.asUint8List();
    // }

    //    Future<void> fetchCategories() async {
    //   try {
    //     final categories = await db.getAllKategoris();
    //     setState(() {
    //       kategoriList = categories;
    //       if (widget.produk != null) {
    //         selectedKategoriId = widget.produk!.getKategori;
    //       }
    //     });
    //   } catch (e) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text("Failed to load categories"),
    //       ),
    //     );
    //   }
    // }

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

                            // FutureBuilder<String>(
                            //   future: getKategoriNama(widget.produk.kategori),
                            //   builder: (context, snapshot) {
                            //     if (snapshot.connectionState ==
                            //         ConnectionState.waiting) {
                            //       return Text(
                            //         "Memuat kategori...",
                            //         style: TextStyle(color: Colors.grey),
                            //       );
                            //     }
                            //     if (snapshot.hasError || !snapshot.hasData) {
                            //       return Text(
                            //         "Kategori Tidak Diketahui",
                            //         style: TextStyle(color: Colors.red),
                            //       );
                            //     }
                            //     print('kategorinya ${snapshot.data!}');
                            //     return Text(
                            //       snapshot.data!,
                            //       style: TextStyle(
                            //         fontWeight: FontWeight.bold,
                            //         color: Colors.black54,
                            //       ),
                            //     );
                            //   },
                            // ),
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
                onTap: () {
                  // showDialog(
                  //   context: context,
                  //   builder: (context) => AlertDialog(
                  //     title: Text('Update Product'),
                  //     content: SingleChildScrollView(
                  //       child: Column(
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: [
                  //           TextField(
                  //             controller: widget.produk.nama == null
                  //                 ? _namaController
                  //                 : _namaController
                  //               ..text = widget.produk.nama,
                  //             decoration: InputDecoration(
                  //               hintText: 'Nama',
                  //             ),
                  //           ),
                  //           TextField(
                  //             controller: widget.produk.deskripsi == null
                  //                 ? _deskripsiController
                  //                 : _deskripsiController
                  //               ..text = widget.produk.deskripsi,
                  //             decoration: InputDecoration(
                  //               hintText: 'Deskripsi',
                  //             ),
                  //           ),
                  //           TextField(
                  //             controller: widget.produk.harga == null
                  //                 ? _hargaController
                  //                 : _hargaController
                  //               ..text = widget.produk.harga.toString(),
                  //             decoration: InputDecoration(
                  //               hintText: 'Harga',
                  //             ),
                  //           ),
                  //           TextField(
                  //             controller: widget.produk.kategori == null
                  //                 ? _kategoriController
                  //                 : _kategoriController
                  //               ..text = widget.produk.kategori,
                  //             decoration: InputDecoration(
                  //               hintText: 'Kategori',
                  //             ),
                  //           ),
                  //           TextField(
                  //             controller: widget.produk.stock == null
                  //                 ? _stockController
                  //                 : _stockController
                  //               ..text = widget.produk.stock.toString(),
                  //             decoration: InputDecoration(
                  //               hintText: 'Kategori',
                  //             ),
                  //           ),
                  //           TextField(
                  //             controller: widget.produk.gambar == null
                  //                 ? _gambarController
                  //                 : _gambarController
                  //               ..text = widget.produk.gambar,
                  //             decoration: InputDecoration(
                  //               hintText: 'Gambar',
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     actions: [
                  //       TextButton(
                  //         onPressed: () => Navigator.pop(context),
                  //         child: const Text('Batalkan'),
                  //       ),
                  //       TextButton(
                  //         onPressed: () {
                  //           updateProduct();
                  //           Navigator.pop(context);
                  //         },
                  //         child: const Text('Update'),
                  //       )
                  //     ],
                  //   ),
                  // );
                },
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red),
                  ),
                  child: ClipOval(
                    // child: Image.memory(
                    //   Base64Decoder().convert(widget.barang.gambar!),
                    //   fit: BoxFit.cover,
                    // ),
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
