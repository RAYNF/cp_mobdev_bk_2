//belum sama didownload

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_inventory/data/helpers/dbhelper.dart';
import 'package:mobile_inventory/data/models/sqflite/kategories_model.dart';
import 'package:mobile_inventory/data/models/sqflite/product_models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_inventory/presentation/utils/input_validators.dart';

class AddproductScreen extends StatefulWidget {
  final Product? produk;
  const AddproductScreen({super.key, this.produk});
  static const routeName = '/addproduct';

  @override
  State<AddproductScreen> createState() => _AddproductScreenState();
}

class _AddproductScreenState extends State<AddproductScreen> {
  Dbhelper db = Dbhelper();
  TextEditingController? nama = TextEditingController();
  TextEditingController? deskripsi = TextEditingController();
  TextEditingController? harga = TextEditingController();
  TextEditingController? stock = TextEditingController();

  final ImagePicker imgpicker = ImagePicker();
  final String defaultImage = 'assets/images/episode1.jpg';
  String imagepath = "";
  String imageBase64 = "";

  List<Kategories> kategoriList = [];
  int? selectedKategoriId;
  final _formKey = GlobalKey<FormState>();

  Future<void> openImage(ImageSource sources) async {
    try {
      final pickedFile = await imgpicker.pickImage(source: sources);

      if (pickedFile != null) {
        imagepath = pickedFile.path;

        File imageFile = File(imagepath);
        Uint8List imagebytes = await imageFile.readAsBytes();
        String base64string = base64.encode(imagebytes);

        setState(() {
          imageBase64 = base64string;
        });
      }
    } catch (e) {
      print("error whiling picking file");
    }
  }

  Future<void> upsertProduct() async {
    if (widget.produk != null) {
      final updatedProduct = Product.fromMap({
        'id': widget.produk!.getId,
        'nama': nama!.text,
        'deskripsi': deskripsi!.text,
        'harga': int.parse(harga!.text),
        // 'kategori': int.parse(kategori!.text),
        'kategori': selectedKategoriId!,
        'stock': int.parse(stock!.text),
        'gambar': imageBase64,
      });

      await db.updateProduct(updatedProduct);

      final productData =
          await db.getProductWithCategoryById(updatedProduct.getId);

      Navigator.pushReplacementNamed(context, '/detail',
          arguments: productData);
    } else {
      await db.saveProduct(
        Product(
          nama!.text,
          deskripsi!.text,
          int.parse(harga!.text),
          selectedKategoriId!,
          int.parse(stock!.text),
          imageBase64.isNotEmpty
              ? imageBase64
              : base64.encode(
                  await loadDefaultImageBytes(),
                ),
        ),
      );
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  Future<Uint8List> loadDefaultImageBytes() async {
    ByteData bytes = await DefaultAssetBundle.of(context).load(defaultImage);
    return bytes.buffer.asUint8List();
  }

  Future<void> fetchCategories() async {
    try {
      final categories = await db.getAllKategoris();
      setState(() {
        kategoriList = categories;
        if (widget.produk != null) {
          selectedKategoriId = widget.produk!.getKategori;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to load categories"),
        ),
      );
    }
  }

  @override
  void initState() {
    nama = TextEditingController(
        text: widget.produk == null ? '' : widget.produk!.getName);
    deskripsi = TextEditingController(
        text: widget.produk == null ? '' : widget.produk!.getDeskripsi);
    harga = TextEditingController(
        text: widget.produk == null
            ? 0.toString()
            : widget.produk!.getHarga.toString());
    stock = TextEditingController(
        text: widget.produk == null
            ? 0.toString()
            : widget.produk!.getStock.toString());

    imageBase64 = widget.produk == null ? '' : widget.produk!.getGambar;

    fetchCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form Product"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: nama,
              validator: notEmptyString,
              decoration: InputDecoration(
                labelText: "Nama barang",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: deskripsi,
              validator: notEmptyString,
              decoration: InputDecoration(
                labelText: "Deskripsi barang",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: harga,
              validator: notEmptyInt,
              decoration: InputDecoration(
                labelText: "Harga barang",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<int>(
              validator: notEmptyInt,
              value: selectedKategoriId,
              items: kategoriList.map((kategori) {
                return DropdownMenuItem<int>(
                  value:
                      kategori.getId, // Nilai yang dikirim adalah ID kategori
                  child: Text(kategori.getName), // Nama yang ditampilkan
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedKategoriId =
                      value; // Perbarui ID kategori yang dipilih
                });
              },
              decoration: InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: stock,
              validator: notEmptyInt,
              decoration: InputDecoration(
                labelText: "Stock barang",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: imageBase64.isNotEmpty
                      ? Image.memory(Base64Decoder().convert(imageBase64))
                      : Image.asset(defaultImage, fit: BoxFit.cover),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async =>
                          await openImage(ImageSource.camera),
                      icon: const Icon(Icons.camera),
                      label: const Text("Camera"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () async =>
                          await openImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo),
                      label: const Text("Gallery"),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  upsertProduct();
                }
              },
              child: widget.produk == null
                  ? const Text('Add')
                  : const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}