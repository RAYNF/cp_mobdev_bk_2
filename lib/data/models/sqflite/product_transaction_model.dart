class Producttransaction {
  int _id = 0;
  String _productName = "";
  int _productQuantity = 0;
  int _productDate = 0;
  // String _kategori = "";

  String _productType = "";
  String? gambar;

  Producttransaction(
    this._productName,
    this._productQuantity,
    this._productDate,
    this._productType,
    this.gambar,
  );

  Producttransaction.fromMap(Map<String, dynamic> map) {
    _id = map['product_id'];
    _productName = map['product_name'];
    _productQuantity = map['product_quantity'];
    _productDate = map['product_transaction'];
    _productType = map['product_type'];
    gambar = map['product_gambar'];
  }

  int get getId => _id;
  String get getProductName => _productName;
  int get getProductQuantity => _productQuantity;
  int get getProductDate => _productDate;
  String get getProductType => _productType;
  String get getProductGambar => gambar!;

  set setProcutName(String value) {
    _productName = value;
  }

  set setProductQuantity(int value) {
    _productQuantity = value;
  }

  set setProductDate(int value) {
    _productDate = value;
  }

  set setProductType(String value) {
    _productType = value;
  }

  set setProductGambar(String value) {
    gambar = value;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['product_name'] = _productName;
    map['product_quantity'] = _productQuantity;
    map['product_transaction'] = _productDate;
    map['product_type'] = _productType;
    map['gambar'] = gambar;
    return map;
  }
}
