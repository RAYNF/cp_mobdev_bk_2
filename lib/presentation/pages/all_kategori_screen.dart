import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_inventory/data/helpers/dbhelper.dart';
import 'package:mobile_inventory/data/models/firebase/kategori_model.dart';
import 'package:mobile_inventory/data/models/sqflite/kategories_model.dart';
import 'package:mobile_inventory/presentation/pages/add_categori_screen.dart';
import 'package:mobile_inventory/presentation/pages/dashboard_screen.dart';
import 'package:mobile_inventory/presentation/widgets/item_kategori_widget.dart';

class AllkategoriScreen extends StatefulWidget {
  const AllkategoriScreen({super.key});

  @override
  State<AllkategoriScreen> createState() => _AllKategoriScreenState();
}

class _AllKategoriScreenState extends State<AllkategoriScreen> {
  List<Kategories> listKategori = [];
  // Dbhelper db = Dbhelper();

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _namaController = TextEditingController();
  TextEditingController _deskripsiController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  bool isComplete = false;

  // Future<void> _getAllKategori() async {
  //   var list = await db.getAllKategoris();

  //   setState(() {
  //     listKategori = list;
  //   });
  // }

  // Future<void> deleteKategori(int id, String name) async {
  //   final db = Dbhelper();

  //   try {
  //     await db.deleteKategories(id);

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("${name} delete succes"),
  //       ),
  //     );

  //     Navigator.pushNamed(context, '/dashboard');
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Failed to delete ${name} because $e"),
  //       ),
  //     );
  //   }
  // }

  Stream<QuerySnapshot<Map<String, dynamic>>> searchStream(String textEntered) {
    if (textEntered.isEmpty) {
      return _firestore.collection('kategori').snapshots();
    } else {
      return _firestore
          .collection('kategori')
          .where('nama', isEqualTo: textEntered)
          .snapshots();
    }
  }

  void clearText() {
    _namaController.clear();
    _deskripsiController.clear();
  }

  @override
  void initState() {
    // _getAllKategori();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    var colref = _firestore.collection('kategori');

    Future<void> AddKategori() {
      return colref.add({
        'nama': _namaController.text,
        'deskripsi': _deskripsiController.text,
        'uid': _auth.currentUser!.uid
      }).catchError(
        (error) => print(
          "Failed to add kategori: $error",
        ),
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        child: Icon(Icons.add),
        onPressed: () {
          // Navigator.pushNamed(context, '/addkategori');
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Tambah Kategori'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                        labelText: 'Nama kategori',
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _deskripsiController,
                    decoration: const InputDecoration(
                        labelText: "Deskripsi Kategori",
                        border: OutlineInputBorder()),
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Batal",
                  ),
                ),
                TextButton(
                  onPressed: () {
                    AddKategori();
                    clearText();
                    Navigator.pop(context);
                  },
                  child: const Text("simpan"),
                )
              ],
            ),
          );
        },
      ),
      appBar: AppBar(
        title: Text("Daftar Kategori"),
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
      body:
          // child: Padding(
          //   padding: EdgeInsets.all(8),
          //   child: ListView.builder(
          //     itemCount: listKategori.length,
          //     itemBuilder: (context, index) {
          //       return ListTile(
          //         leading: IconButton(
          //           onPressed: () {
          //             // deleteKategori(
          //             //     listKategori[index].getId, listKategori[index].getName);
          //           },
          //           icon: Icon(Icons.remove),
          //         ),
          //         trailing: IconButton(
          //             onPressed: () {
          //               Navigator.push(context,
          //                   MaterialPageRoute(builder: (context) {
          //                 return AddcategoriScreen(
          //                   kategori: listKategori[index],
          //                 );
          //               }));
          //             },
          //             icon: Icon(Icons.edit)),
          //         title: Text(listKategori[index].getName),
          //         subtitle: Text(listKategori[index].getDeskripsi),
          //       );
          //     },
          //   ),
          // ),
          Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 10,
            ),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
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
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('Tidak ada data ditemukan'),
                  );
                }

                List<Kategori> listKategori =
                    snapshot.data!.docs.map((document) {
                  final data = document.data();
                  final String nama = data['nama'];
                  final String deskripsi = data['deskripsi'];
                  final String uid = user!.uid;

                  return Kategori(uid, nama: nama, deskripsi: deskripsi);
                }).toList();

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: listKategori.length,
                  itemBuilder: (context, index) {
                    return ItemKategori(
                        kategori: listKategori[index],
                        transaksiDocId: snapshot.data!.docs[index].id);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
