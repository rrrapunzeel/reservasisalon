class Perawatan {
  int? idPerawatan;
  int? idKategori;
  String? namaPerawatan;
  double? hargaPerawatan;
  bool isAddedToCart = false;
  bool selected = true;
  List<Perawatan>? _subPerawatan;

  List<Perawatan>? get subPerawatan => _subPerawatan;

  set subPerawatan(List<Perawatan>? value) {
    _subPerawatan = value;
  }

  Perawatan({
    this.idPerawatan,
    this.idKategori,
    this.namaPerawatan,
    this.hargaPerawatan,
    this.selected = false,
  });

  Perawatan.fromJson(Map<String, dynamic> json) {
    idPerawatan = json['id_perawatan'] as int?;
    idKategori = json['id_kategori'] as int?;
    namaPerawatan = json['nama_perawatan'] as String?;
    // Handle type casting for hargaPerawatan
    final hargaPerawatanValue = json['harga_perawatan'];
    if (hargaPerawatanValue is double) {
      hargaPerawatan = hargaPerawatanValue;
    } else if (hargaPerawatanValue is int) {
      hargaPerawatan = hargaPerawatanValue.toDouble();
    } else if (hargaPerawatanValue is String) {
      hargaPerawatan = double.tryParse(hargaPerawatanValue);
    }
    // Handle nullable fields
    isAddedToCart = false;
    selected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id_perawatan'] = idPerawatan;
    data['id_kategori'] = idKategori;
    data['nama_perawatan'] = namaPerawatan;
    data['harga_perawatan'] = hargaPerawatan;
    return data;
  }

  void setAddedToCart(bool value) {
    isAddedToCart = value;
  }
}
