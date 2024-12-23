class ProductWithCategory {
  int? id;
  String? nama;
  String? deskripsi;
  int? harga;
  int? stock;
  String? gambar;
  String? kategoriName;

  ProductWithCategory({
    this.id,
    this.nama,
    this.deskripsi,
    this.harga,
    this.stock,
    this.gambar,
    this.kategoriName,
  });

  factory ProductWithCategory.fromMap(Map<String, dynamic> map) {
    return ProductWithCategory(
      id: map['product_id'],
      nama: map['product_name'],
      deskripsi: map['product_deskripsi'],
      harga: map['product_harga'],
      stock: map['product_stock'],
      gambar: map['product_gambar'],
      kategoriName: map['kategori_name'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nama': nama,
      'deskripsi': deskripsi,
      'harga': harga,
      'kategori': kategoriName,
      'stock': stock,
      'gambar': gambar
    };
  }
}
