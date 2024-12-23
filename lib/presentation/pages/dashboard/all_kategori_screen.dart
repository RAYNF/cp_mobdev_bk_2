import 'package:flutter/material.dart';
import 'package:mobile_inventory/data/helpers/dbhelper.dart';
import 'package:mobile_inventory/data/models/sqflite/kategories_model.dart';
import 'package:mobile_inventory/presentation/pages/add_categori_screen.dart';

class AllkategoriScreen extends StatefulWidget {
  const AllkategoriScreen({super.key});

  @override
  State<AllkategoriScreen> createState() => _AllKategoriScreenState();
}

class _AllKategoriScreenState extends State<AllkategoriScreen> {
  List<Kategories> listKategori = [];
  Dbhelper db = Dbhelper();

  Future<void> _getAllKategori() async {
    var list = await db.getAllKategoris();

    setState(() {
      listKategori = list;
    });
  }

  Future<void> deleteKategori(int id, String name) async {
    final db = Dbhelper();

    try {
      await db.deleteKategories(id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${name} delete succes"),
        ),
      );

      Navigator.pushNamed(context, '/dashboard');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete ${name} because $e"),
        ),
      );
    }
  }

  @override
  void initState() {
    _getAllKategori();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/addkategori');
        },
      ),
      appBar: AppBar(
        title: Text("Daftar Kategori"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: listKategori.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: IconButton(
                onPressed: () {
                  deleteKategori(
                      listKategori[index].getId, listKategori[index].getName);
                },
                icon: Icon(Icons.remove),
              ),
              trailing: IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AddcategoriScreen(
                        kategori: listKategori[index],
                      );
                    }));
                  },
                  icon: Icon(Icons.edit)),
              title: Text(listKategori[index].getName),
              subtitle: Text(listKategori[index].getDeskripsi),
            );
          },
        ),
      )),
    );
  }
}
