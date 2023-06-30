import 'package:intl/intl.dart';

class Reservasi {
  DateTime? date;
  int? idTimeSlots;
  String? nama;
  String? email;

  Reservasi(
      {required this.date, required this.idTimeSlots, this.nama, this.email});

  Reservasi.fromJson(Map<String, dynamic> json) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    date = json['date'] != null ? DateTime.parse(json['date']) : null;
    idTimeSlots = json['id_time_slots'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = DateTime(
      date!.year,
      date!.month,
      date!.day,
    ).toIso8601String();
    data['id_time_slots'] = this.idTimeSlots;
    return data;
  }
}
