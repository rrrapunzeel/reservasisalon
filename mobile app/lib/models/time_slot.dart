import 'package:intl/intl.dart';

class TimeSlot {
  int? id;
  String? idPegawai;
  late DateTime jamPerawatan; // Updated to non-nullable DateTime
  bool? available;
  bool isSelected;
  late DateTime? tanggal;
  int? idTimeSlots;

  TimeSlot({
    this.id,
    this.idPegawai,
    this.available,
    required this.jamPerawatan,
    required this.tanggal,
    this.isSelected = false,
    this.idTimeSlots,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    final DateFormat timeFormat = DateFormat('HH:mm:ss');
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return TimeSlot(
      id: json['id'],
      idPegawai: json['idPegawai'],
      jamPerawatan: json['jam_perawatan'] != null
          ? timeFormat.parse(json['jam_perawatan'] as String)
          : DateTime.now(),
      tanggal: json['tanggal'] != null
          ? dateFormat.parse(json['tanggal'] as String)
          : null,
      available: json['available'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['idPegawai'] = idPegawai;
    data['jam_perawatan'] = DateFormat.Hm().format(jamPerawatan);
    data['tanggal'] = tanggal != null
        ? DateTime(tanggal!.year, tanggal!.month, tanggal!.day)
            .toIso8601String()
        : null;
    data['available'] = available;
    return data;
  }
}
