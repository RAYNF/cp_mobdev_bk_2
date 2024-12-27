import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_inventory/data/models/firebase/kategori_model.dart';
import 'package:mobile_inventory/presentation/widgets/input_widget.dart';

class ItemKategori extends StatelessWidget {
  final String transaksiDocId;
  final Kategori kategori;
  const ItemKategori(
      {super.key, required this.kategori, required this.transaksiDocId});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    CollectionReference kategoriCollection = _firestore.collection('kategori');
    TextEditingController _titleController = TextEditingController();
    TextEditingController _deksripsiController = TextEditingController();

    Future<void> deleteKategories() async {
      await _firestore.collection('kategori').doc(transaksiDocId).delete();
    }

    Future<void> updateKategori() async {
      await _firestore.collection('kategori').doc(transaksiDocId).update({
        'nama': _titleController.text,
        'deskripsi': _deksripsiController.text
      });
    }

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Update Kategori',
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: kategori.nama == null
                      ? _titleController
                      : _titleController
                    ..text = kategori.nama,
                  decoration: InputDecoration(
                    hintText: 'nama',
                  ),
                ),
                TextField(
                  controller: kategori.deskripsi == null
                      ? _deksripsiController
                      : _deksripsiController
                    ..text = kategori.deskripsi,
                  decoration: InputDecoration(hintText: "Deskripsi"),
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Batalkan',
                ),
              ),
              TextButton(
                onPressed: () {
                  updateKategori();
                  Navigator.pop(context);
                },
                child: const Text('Update'),
              )
            ],
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 6,
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    kategori.nama,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    kategori.deskripsi,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            IconButton(
              onPressed: () {
                deleteKategories();
              },
              icon: Icon(
                Icons.remove,
              ),
            )
          ],
        ),
      ),
    );
  }
}
