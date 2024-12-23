class Product {
  int _id = 0;
  String _nama = "";
  String _deskripsi = "";
  int _harga = 0;
  // String _kategori = "";
  int _kategori = 0;
  int _stock = 0;
  String _gambar = "";

  Product(
    this._nama,
    this._deskripsi,
    this._harga,
    this._kategori,
    this._stock,
    this._gambar,
  );

  Product.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _nama = map['nama'];
    _deskripsi = map['deskripsi'];
    _harga = map['harga'];
    _kategori = map['kategori'];
    _stock = map['stock'];
    _gambar = map['gambar'];
  }

  int get getId => _id;
  String get getName => _nama;
  String get getDeskripsi => _deskripsi;
  int get getHarga => _harga;
  int get getKategori => _kategori;
  int get getStock => _stock;
  String get getGambar => _gambar;

  set setNama(String value) {
    _nama = value;
  }

  set setDeskripsi(String value) {
    _deskripsi = value;
  }

  set setHarga(int value) {
    _harga = value;
  }

  set setKategori(int value) {
    _kategori = value;
  }

  set setStock(int value) {
    _stock = value;
  }

  set setGambar(String value) {
    _gambar = value;
  }


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nama': _nama,
      'deskripsi': _deskripsi,
      'harga': _harga,
      'kategori': _kategori,
      'stock': _stock,
      'gambar': _gambar
    };
  }

  Product copyWith({
    String? nama,
    String? deskripsi,
    int? harga,
    int? kategori,
    int? stock,
    String? gambar,
  }) {
    return Product(
      nama ?? _nama,
      deskripsi ?? _deskripsi,
      harga ?? _harga,
      kategori ?? _kategori,
      stock ?? _stock,
      gambar ?? _gambar,
    );
  }
}
