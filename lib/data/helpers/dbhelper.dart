import 'package:mobile_inventory/data/models/sqflite/kategories_model.dart';
import 'package:mobile_inventory/data/models/sqflite/product_models.dart';
import 'package:mobile_inventory/data/models/sqflite/product_categories_model.dart';
import 'package:mobile_inventory/data/models/sqflite/product_transaction_model.dart';
import 'package:mobile_inventory/data/models/sqflite/transaction_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class Dbhelper {
  static final Dbhelper _instance = Dbhelper._internal();
  static Database? _database;

  final String tableName1 = 'product';
  final String tableName2 = 'kategories';
  final String tableName3 = 'history';

  final String columnKategori = 'kategori';

  //3 tabel
  final String columnId = 'id';

  //2 tabel product dan kategori
  final String columnName = 'nama';
  final String columnDeskripsi = 'deskripsi';
  final String columnStock = 'stock';

  //coloumn tabel product
  final String columnHarga = 'harga';
  final String columnGambar = 'gambar';

  //column tabel history
  final String columnProductIdTransaction = 'productidtransaction';
  final String columnProductQuantityTransaction = 'productquantitytransaction';
  final String columnProductTypeTransaction = 'producttypetransaction';
  final String columnProductDateTransaction = 'productdatetrancasction';

  Dbhelper._internal();
  factory Dbhelper() => _instance;

  Future<Database?> get _db async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDb();
    return _database;
  }

  Future<Database?> _initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'product_kategories.db');
    return await openDatabase(path,
        version: 1, onCreate: _onCreate, onConfigure: _onConfigure);
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableName2(
    $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnName TEXT NOT NULL,
    $columnDeskripsi TEXT
    )
''');

    await db.execute('''
    CREATE TABLE $tableName1(
    $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnName TEXT ,
    $columnDeskripsi TEXT,
    $columnHarga INTEGER,
    $columnKategori INTEGER REFERENCES kategories(id) ON DELETE SET NULL,
    $columnStock INTEGER,
    $columnGambar TEXT
    )
''');

    await db.execute('''
    CREATE TABLE $tableName3(
    $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnProductIdTransaction INTEGER REFERENCES product(id) ON DELETE SET NULL,
    $columnProductQuantityTransaction INTEGER,
    $columnProductDateTransaction INTEGER,
    $columnProductTypeTransaction TEXT,
    $columnGambar TEXT
    )
''');
  }

  Future<int?> saveTransactions(Transactions transaction) async {
    var dbClient = await _db;
    return await dbClient!.insert(tableName3, transaction.toMap());
  }

  Future<List<Transactions>> getAllTransactions() async {
    var dbClient = await _db;
    var result = await dbClient!.query(tableName3);
    return result.map((results) => Transactions.fromMap(results)).toList();
  }

  Future<List<Producttransaction>> getTransactionProductById(int id) async {
    var dbClient = await _db;

    // Menggunakan raw SQL query dengan LEFT JOIN dan WHERE untuk filter berdasarkan id
    var result = await dbClient!.rawQuery('''
    SELECT 
      $tableName3.$columnId AS product_id,
      $tableName1.$columnName AS product_name,
      $tableName3.$columnProductQuantityTransaction AS product_quantity,
      $tableName3.$columnProductDateTransaction AS product_transaction,
      $tableName3.$columnProductTypeTransaction AS product_type,
      $tableName1.$columnGambar AS product_gambar
    FROM $tableName3
    LEFT JOIN $tableName1
    ON $tableName1.$columnId = $tableName3.$columnProductIdTransaction
    WHERE $tableName3.$columnProductIdTransaction = ?
  ''', [id]); // Parameter id

    // Mengembalikan hasil query dalam bentuk list of Producttransaction
    return result.map((map) => Producttransaction.fromMap(map)).toList();
  }

  Future<int?> saveKategoris(Kategories kategori) async {
    var dbClient = await _db;
    return await dbClient!.insert(tableName2, kategori.toMap());
  }

  Future<List<Producttransaction>> getAllProdukWithTransaction() async {
    var dbClient = await _db;

    var result = await dbClient!.rawQuery('''
    SELECT 
      $tableName3.$columnId AS product_id,
      $tableName1.$columnName AS product_name,
      $tableName3.$columnProductQuantityTransaction AS product_quantity,
      $tableName3.$columnProductDateTransaction AS product_transaction,
      $tableName3.$columnProductTypeTransaction AS product_type,
      $tableName1.$columnGambar AS product_gambar
    FROM $tableName3 LEFT JOIN $tableName1
    ON $tableName1.$columnId = $tableName3.$columnProductIdTransaction
  ''');

    // Konversi setiap hasil query ke dalam model ProductWithCategory
    return result.map((map) => Producttransaction.fromMap(map)).toList();
  }

  Future<int?> deleteTransaction(int id) async {
    var dbClient = await _db;
    return await dbClient!
        .delete(tableName3, where: '$columnId= ?', whereArgs: [id]);
  }

  Future<List<Kategories>> getAllKategoris() async {
    var dbClient = await _db;
    var result = await dbClient!.query(tableName2);
    return result.map((results) => Kategories.fromMap(results)).toList();
  }

  Future<int?> deleteKategories(int id) async {
    var dbClient = await _db;
    return await dbClient!
        .delete(tableName2, where: '$columnId= ?', whereArgs: [id]);
  }

  Future<int?> updateKategoris(Kategories kategori) async {
    var dbClient = await _db;
    return await dbClient!.update(tableName2, kategori.toMap(),
        where: '$columnId = ?', whereArgs: [kategori.getId]);
  }

  Future<int?> saveProduct(Product product) async {
    var dbClient = await _db;
    return await dbClient!.insert(tableName1, product.toMap());
  }


  Future<List<ProductWithCategory>> getAllProdukWithKategoriName() async {
    var dbClient = await _db;

    var result = await dbClient!.rawQuery('''
    SELECT 
      $tableName1.$columnId AS product_id,
      $tableName1.$columnName AS product_name,
      $tableName1.$columnDeskripsi AS product_deskripsi,
      $tableName1.$columnHarga AS product_harga,
      $tableName1.$columnGambar AS product_gambar,
      $tableName1.$columnStock AS product_stock,
      $tableName2.$columnName AS kategori_name 
    FROM $tableName1
    LEFT JOIN $tableName2
    ON $tableName1.$columnKategori = $tableName2.$columnId
  ''');

    // Konversi setiap hasil query ke dalam model ProductWithCategory
    return result.map((map) => ProductWithCategory.fromMap(map)).toList();
  }

  Future<int?> updateProduct(Product product) async {
    var dbClient = await _db;
    return await dbClient!.update(tableName1, product.toMap(),
        where: '$columnId = ?', whereArgs: [product.getId]);
  }

  Future<int?> deleteProduct(int id) async {
    var dbClient = await _db;
    return await dbClient!
        .delete(tableName1, where: '$columnId= ?', whereArgs: [id]);
  }

  Future<Product> getProductById(int id) async {
    var dbclient = await _db;
    var products =
        await dbclient!.query(tableName1, where: 'id = ?', whereArgs: [id]);
    return products.map((todo) => Product.fromMap(todo)).single;
  }

  Future<ProductWithCategory> getProductWithCategoryById(int id) async {
    var dbclient = await _db;
    var result = await dbclient!.rawQuery('''
    SELECT 
      $tableName1.$columnId AS product_id,
      $tableName1.$columnName AS product_name,
      $tableName1.$columnDeskripsi AS product_deskripsi,
      $tableName1.$columnHarga AS product_harga,
      $tableName1.$columnGambar AS product_gambar,
      $tableName1.$columnStock AS product_stock,
      $tableName2.$columnName AS kategori_name
    FROM $tableName1
    LEFT JOIN $tableName2
    ON $tableName1.$columnKategori = $tableName2.$columnId
    WHERE $tableName1.$columnId = ?
  ''', [id]);

    return result.map((todo) => ProductWithCategory.fromMap(todo)).single;
  }
}
