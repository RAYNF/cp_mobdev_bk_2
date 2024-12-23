class Transactions {
  int _id = 0;
  int _productId = 0;
  int _productQuantity = 0;
  int _productDate = 0;
  // String _kategori = "";

  String _productType = "";
  String? gambar;

  Transactions(
    this._productId,
    this._productQuantity,
    this._productDate,
    this._productType,
    this.gambar,
  );

  Transactions.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _productId = map['productidtransaction'];
    _productQuantity = map['productquantitytransaction'];
    _productDate = map['productdatetrancasction'];
    _productType = map['producttypetransaction'];
    gambar = map['product_gambar'];
  }

  int get getId => _id;
  int get getProductId => _productId;
  int get getProductQuantity => _productQuantity;
  int get getProductDate => _productDate;

  String get getProductType => _productType;
  String get getProductGambar => gambar!;

  set setProcutId(int value) {
    _productId = value;
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
    map['productidtransaction'] = _productId;
    map['productquantitytransaction'] = _productQuantity;
    map['productdatetrancasction'] = _productDate;
    map['producttypetransaction'] = _productType;
    map['gambar'] = gambar;
    return map;
  }
}
