import 'package:flutter/material.dart';
import 'package:mobile_inventory/data/helpers/dbhelper.dart';
import 'package:mobile_inventory/data/models/sqflite/kategories_model.dart';

class AddcategoriScreen extends StatefulWidget {
  final Kategories? kategori;
  static const routeName = '/addkategori';
  const AddcategoriScreen({super.key, this.kategori});

  @override
  State<AddcategoriScreen> createState() => _AddcategoriScreenState();
}

class _AddcategoriScreenState extends State<AddcategoriScreen> {
  Dbhelper db = Dbhelper();
  TextEditingController? nama;
  TextEditingController? deskripsi;

  Future<void> upsertKategori() async {
    if (widget.kategori != null) {
      final updateKategori = Kategories.fromMap({
        'id': widget.kategori!.getId,
        'nama': nama!.text,
        'deskripsi': deskripsi!.text,
      });

      await db.updateKategoris(updateKategori);

      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      await db.saveKategoris(
        Kategories(
          nama!.text,
          deskripsi!.text,
        ),
      );
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  void initState() {
    super.initState();

    nama = TextEditingController(
        text: widget.kategori == null ? '' : widget.kategori!.getName);
    deskripsi = TextEditingController(
        text: widget.kategori == null ? '' : widget.kategori!.getDeskripsi);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form Product"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: nama,
            decoration: InputDecoration(
                labelText: 'Nama barang',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: deskripsi,
            decoration: InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                )),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: upsertKategori,
            child: widget.kategori == null
                ? const Text('Add')
                : const Text('Update'),
          ),
        ],
      ),
    );
  }
}
