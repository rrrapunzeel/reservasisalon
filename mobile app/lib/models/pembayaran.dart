import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum StatusTransaksi {
  success,
  pending,
  cancel,
  failed,
  done,
  unknown,
}

StatusTransaksi getStatusFromString(String? statusString) {
  switch (statusString) {
    case 'Berhasil':
      return StatusTransaksi.success;
    case 'Tertunda':
      return StatusTransaksi.pending;
    case 'Gagal':
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
  String items;
  String? pegawai;
  late DateTime jam;
  late DateTime tanggal;
  String? statusTransaksi;
  final Color statusColor;
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
    required this.statusColor,
  });

  factory Pembayaran.fromJson(Map<String, dynamic> json) {
    final DateFormat timeFormat = DateFormat('HH:mm');
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    final String? statusTransaksi = json['transaction_status'] as String?;
    final Color statusColor = _getStatusColor(statusTransaksi);

    return Pembayaran(
      nama: json['nama'] as String?,
      email: json['email'] as String?,
      total: json['total'] != null ? json['total'].toDouble() : null,
      snapToken: json['snap_token'] as String?,
      id: json['id'] as int?,
      idReservasi: json['id_reservasi'] as String?,
      idTransaksi: json['transaction_id'] as String?,
      items: json['items'] != null ? jsonEncode(json['items']) : '',
      pegawai: json['pegawai'] as String?,
      jam: json['jam'] != null
          ? timeFormat.parse(json['jam'] as String)
          : DateTime.now(),
      tanggal: json['tanggal'] != null
          ? DateTime.parse(json['tanggal'])
          : DateTime.now(),
      statusTransaksi: statusTransaksi,
      notification: json['notification'] as bool?,
      statusColor: statusColor,
    );
  }

  Map<String, dynamic> toJson() {
    final DateFormat timeFormat = DateFormat('HH:mm');
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    final Map<String, dynamic> data = {};
    data['nama'] = nama;
    data['email'] = email;
    data['total'] = total;
    data['snap_token'] = snapToken;
    data['id'] = id;
    data['id_reservasi'] = idReservasi;
    data['transaction_id'] = idTransaksi;
    data['items'] = items != null
        ? jsonDecode(items!)
        : null; // Menggunakan jsonEncode untuk mengonversi List<dynamic> menjadi JSON
    data['pegawai'] = pegawai;
    data['jam'] = timeFormat.format(jam);
    data['tanggal'] = dateFormat.format(tanggal);
    data['transaction_status'] = statusTransaksi;
    data['notification'] = notification;
    return data;
  }

  static Color _getStatusColor(String? status) {
    switch (getStatusFromString(status)) {
      case StatusTransaksi.success:
        return Colors.green;
      case StatusTransaksi.pending:
        return Colors.yellow;
      case StatusTransaksi.failed:
        return Colors.red;
      case StatusTransaksi.cancel:
        return const Color.fromARGB(255, 165, 13, 2);
      case StatusTransaksi.done:
        return const Color.fromARGB(255, 2, 100, 165);
      default:
        return Colors.grey;
    }
  }
}
