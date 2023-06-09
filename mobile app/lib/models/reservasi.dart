class Reservasi {
  int? idReservasi;
  int? idPerawatan;
  String? namaPerawatan;
  late DateTime date;
  int? timeSlotId;
  String? total;
  String? statusReservasi;
  String? createdAt;

  Reservasi(
      {this.idReservasi,
      this.idPerawatan,
      this.namaPerawatan,
      this.timeSlotId,
      this.total,
      this.statusReservasi,
      this.createdAt});

  Reservasi.fromJson(Map<String, dynamic> json) {
    idReservasi = json['id_reservasi'];
    idPerawatan = json['id_perawatan'];
    namaPerawatan = json['nama_perawatan'];
    date = DateTime.parse(json['date']);
    timeSlotId = json['time_slot_id'];
    total = json['total'];
    statusReservasi = json['status_reservasi'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_reservasi'] = this.idReservasi;
    data['id_perawatan'] = this.idPerawatan;
    data['nama_perawatan'] = this.namaPerawatan;
    data['date'] = DateTime(
      date.year,
      date.month,
      date.day,
    ).toIso8601String();
    data['time_slot_id'] = this.timeSlotId;
    data['total'] = this.total;
    data['status_reservasi'] = this.statusReservasi;
    data['created_at'] = this.createdAt;
    return data;
  }
}
