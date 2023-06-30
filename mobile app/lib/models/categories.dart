class Category {
  final int idKategori;
  final String namaKategori;

  const Category({required this.idKategori, required this.namaKategori});

  @override
  String toString() => namaKategori;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        idKategori: json['id_kategori'], namaKategori: json['nama_kategori']);
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      idKategori: map['id_kategori'],
      namaKategori: map['nama_kategori'],
    );
  }
}
