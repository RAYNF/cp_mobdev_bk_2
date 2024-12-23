import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_inventory/data/helpers/dbhelper.dart';
import 'package:mobile_inventory/data/models/sqflite/product_models.dart';
import 'package:mobile_inventory/data/models/sqflite/transaction_model.dart';

class AddtransactionScreen extends StatefulWidget {
  final Product product;
  const AddtransactionScreen({super.key, required this.product});

  @override
  State<AddtransactionScreen> createState() => _AddtransactionScreenState();
}

class _AddtransactionScreenState extends State<AddtransactionScreen> {
  final _quantityController = TextEditingController();
  String? _transactionType;
  DateTime? _selectedDate;
  final List<String> _transactionTypes = ['Pembelian', 'Penjualan'];

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> saveTransaction() async {
    final db = Dbhelper();

    try {
      final quantity = int.tryParse(_quantityController.text) ?? 0;

      if (quantity <= 0 || _transactionTypes == null || _selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Isi data transaksi dengan benar!")),
        );
        return;
      }

      final transaction = await db.saveTransactions(
        Transactions(
            widget.product.getId,
            quantity,
            _selectedDate!.microsecondsSinceEpoch,
            _transactionType!,
            widget.product.getGambar),
      );

      int newStock = widget.product.getStock;
      if (_transactionType == "Penjualan") {
        setState(() {
          newStock -= quantity;
        });
        print("stock saat ini ${newStock.toString()}");
      } else if (_transactionType == "Pembelian") {
        setState(() {
          newStock += quantity;
        });
        print("stock saat ini ${newStock.toString()}");
      }

      final updatedProducts = Product.fromMap({
        'id': widget.product.getId,
        'nama': widget.product.getName,
        'deskripsi': widget.product.getDeskripsi,
        'harga': widget.product.getHarga,
        'kategori': widget.product.getKategori,
        'stock': newStock,
        'gambar': widget.product.getGambar,
      });

      await db.updateProduct(updatedProducts);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Transaksi berhasil disimpan!")),
      );

      final productData =
          await db.getProductWithCategoryById(updatedProducts.getId);

      Navigator.pushReplacementNamed(
        context,
        '/detail',
        arguments: productData,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan transaksi: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form Transaksi"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Produk: ${widget.product.getName}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Jenis Transaksi",
                border: OutlineInputBorder(),
              ),
              value: _transactionType,
              items: _transactionTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _transactionType = value;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "Jumlah", border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: _selectedDate == null
                          ? "pilih tanggal"
                          : "Tanggal: ${DateFormat('EEEE, dd MMM yyyy').format(_selectedDate!)}",
                      border: OutlineInputBorder()),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  saveTransaction();
                },
                child: Text("Simpan Transaksi"))
          ],
        ),
      ),
    );
  }
}
