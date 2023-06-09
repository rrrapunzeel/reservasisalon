class Category {
  final int idKategori;
  final String namaKategori;
  final String imageUrl;

  const Category(
      {required this.idKategori,
      required this.namaKategori,
      required this.imageUrl});

  String toString() => namaKategori;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        idKategori: json['id_kategori'],
        namaKategori: json['nama_kategori'],
        imageUrl: json['image_url']);
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      idKategori: map['id_kategori'],
      namaKategori: map['nama_kategori'],
      imageUrl: map['image_url'],
    );
  }
}
