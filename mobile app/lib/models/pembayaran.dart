import 'dart:convert';

import 'package:intl/intl.dart';

enum StatusTransaksi {
  success,
  pending,
  cancel,
  unknown,
}

StatusTransaksi getStatusFromString(String? statusString) {
  switch (statusString) {
    case 'settlement':
      return StatusTransaksi.success;
    case 'pending':
      return StatusTransaksi.pending;
    case 'cancel':
      return StatusTransaksi.cancel;
    default:
      return StatusTransaksi.unknown;
  }
}

class Pembayaran {
  String? nama;
  String? email;
  double? total;
  String? snapToken;
  int? id;
  String? idReservasi;
  String? idTransaksi;
  String? items;
  String? pegawai;
  late DateTime jam;
  late DateTime tanggal;
  String? statusTransaksi;
  bool? notification;

  Pembayaran({
    required this.nama,
    required this.email,
    required this.total,
    required this.snapToken,
    required this.id,
    required this.idReservasi,
    required this.idTransaksi,
    required this.items,
    required this.pegawai,
    required this.jam,
    required this.tanggal,
    required this.statusTransaksi,
    required this.notification,
  });

  factory Pembayaran.fromJson(Map<String, dynamic> json) {
    final DateFormat timeFormat = DateFormat('HH:mm:ss');

    return Pembayaran(
      nama: json['nama'] as String?,
      email: json['email'] as String?,
      total: json['total'] != null ? json['total'].toDouble() : null,
      snapToken: json['snap_token'] as String?,
      id: json['id'] as int?,
      idReservasi: json['id_reservasi'] as String?,
      idTransaksi: json['transaction_id'] as String?,
      items: json['items'] != null ? jsonEncode(json['items']) : null,
      pegawai: json['pegawai'] as String?,
      jam: json['time'] != null
          ? timeFormat.parse(json['time'])
          : DateTime.now(),
      tanggal: json['tanggal'] != null
          ? DateTime.parse(json['tanggal'])
          : DateTime.now(),
      statusTransaksi: json['transaction_status'] as String?,
      notification: json['notification'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['nama'] = nama;
    data['email'] = email;
    data['total'] = total;
    data['snap_token'] = snapToken;
    data['id'] = id;
    data['id_reservasi'] = idReservasi;
    data['transaction_id'] = idTransaksi;
    data['items'] = items;
    data['pegawai'] = pegawai;
    data['time'] = DateFormat.Hm().format(jam);
    data['tanggal'] = DateFormat('yyyy-MM-dd').format(tanggal);
    data['transaction_status'] = statusTransaksi;
    data['notification'] = notification;
    return data;
  }
}
