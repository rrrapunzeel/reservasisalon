class Perawatan {
  int? idPerawatan;
  int? idKategori;
  String? namaPerawatan;
  double? hargaPerawatan;
  double? hargaDP;
  bool isAddedToCart = false;
  bool selected = true;
  List<Perawatan>? _subPerawatan;
  int? estimasi;

  List<Perawatan>? get subPerawatan => _subPerawatan;

  set subPerawatan(List<Perawatan>? value) {
    _subPerawatan = value;
  }

  Perawatan({
    this.idPerawatan,
    this.idKategori,
    this.namaPerawatan,
    double? hargaPerawatan,
    double? hargaDP,
    required this.estimasi,
    this.selected = false,
  })  : hargaPerawatan = hargaPerawatan ?? 0.0,
        hargaDP = hargaDP ?? (hargaPerawatan ?? 0.0) / 2;

  Perawatan copyWith({
    int? idPerawatan,
    int? idKategori,
    String? namaPerawatan,
    double? hargaPerawatan,
    double? hargaDP,
    bool? selected,
    int? estimasi,
  }) {
    return Perawatan(
      idPerawatan: idPerawatan ?? this.idPerawatan,
      idKategori: idKategori ?? this.idKategori,
      namaPerawatan: namaPerawatan ?? this.namaPerawatan,
      hargaPerawatan: hargaPerawatan ?? this.hargaPerawatan,
      hargaDP: hargaDP ?? this.hargaDP,
      selected: selected ?? this.selected,
      estimasi: estimasi ?? this.estimasi,
    );
  }

  Perawatan.fromJson(Map<String, dynamic> json) {
    idPerawatan = json['id_perawatan'] as int?;
    idKategori = json['id_kategori'] as int?;
    namaPerawatan = json['nama_perawatan'] as String?;
    estimasi = json['estimasi'] as int?;

    // Handle type casting for hargaPerawatan
    final hargaPerawatanValue = json['harga_perawatan'];
    if (hargaPerawatanValue is double) {
      hargaPerawatan = hargaPerawatanValue;
    } else if (hargaPerawatanValue is int) {
      hargaPerawatan = hargaPerawatanValue.toDouble();
    } else if (hargaPerawatanValue is String) {
      hargaPerawatan = double.tryParse(hargaPerawatanValue);
    }

    // Handle type casting for hargaDP
    final hargaDPValue = json['harga_dp'];
    if (hargaDPValue is double) {
      hargaDP = hargaDPValue;
    } else if (hargaDPValue is int) {
      hargaDP = hargaDPValue.toDouble();
    } else if (hargaDPValue is String) {
      hargaDP = double.tryParse(hargaDPValue);
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
    data['harga_dp'] = hargaDP;
    data['estimasi'] = estimasi;
    return data;
  }

  void setAddedToCart(bool value) {
    isAddedToCart = value;
  }
}
