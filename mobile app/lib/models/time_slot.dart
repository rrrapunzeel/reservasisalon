import 'package:intl/intl.dart';

class TimeSlot {
  int? id;
  String? idPegawai;
  late DateTime jamPerawatan;
  bool? available;
  bool isSelected;

  TimeSlot({
    this.id,
    this.idPegawai,
    this.available,
    required this.jamPerawatan,
    this.isSelected = false,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    final DateFormat timeFormat = DateFormat('HH:mm:ss');
    return TimeSlot(
      id: json['id'],
      idPegawai: json['idPegawai'],
      jamPerawatan: timeFormat.parse(json['jam_perawatan']),
      available: json['available'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idPegawai'] = this.idPegawai;
    data['jam_perawatan'] = DateFormat.Hm().format(this.jamPerawatan);
    data['available'] = this.available;
    return data;
  }
}
