class Produk {
  final String uid;
  final String nama;
  final String deskripsi;
  final int harga;
  final String kategori;
  final int stock;
  final String gambar;
  final String supplier;

  Produk(
      {required this.uid,
      required this.nama,
      required this.deskripsi,
      required this.harga,
      required this.kategori,
      required this.stock,
      required this.gambar,
      required this.supplier});

  Produk copyWith(
      {String? uid,
      String? nama,
      String? deskripsi,
      int? harga,
      String? kategori,
      int? stock,
      String? gambar,
      String? supplier}) {
    return Produk(
        uid: uid ?? this.uid,
        nama: nama ?? this.nama,
        deskripsi: deskripsi ?? this.deskripsi,
        harga: harga ?? this.harga,
        kategori: kategori ?? this.kategori,
        stock: stock ?? this.stock,
        gambar: gambar ?? this.gambar,
        supplier: supplier ?? this.supplier);
  }
}
