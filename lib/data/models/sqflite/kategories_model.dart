class Kategories {
  int _id = 0;
  String _nama = "";
  String _deskripsi = "";

  Kategories(
    this._nama,
    this._deskripsi,
  );

  Kategories.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _nama = map['nama'];
    _deskripsi = map['deskripsi'];
  }

  int get getId => _id;
  String get getName => _nama;
  String get getDeskripsi => _deskripsi;

  set setNama(String value) {
    _nama = value;
  }

  set setDeskripsi(String value) {
    _deskripsi = value;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['nama'] = _nama;
    map['deskripsi'] = _deskripsi;

    return map;
  }
}
