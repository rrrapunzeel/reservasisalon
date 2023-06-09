import 'package:http/http.dart' as http;

Future<String> getSnapToken(
    String nama,
    String email,
    int idReservasi,
    int idPerawatan,
    String namaPerawatan,
    int idPegawai,
    DateTime tanggal,
    DateTime jam,
    String total) async {
  String url = 'https://127.0.0.1:8000/pay';

  var response = await http.post(
    Uri.parse(url),
    body: {
      'nama': nama,
      'email': email,
      'id_reservasi': idReservasi.toString(),
      'id_perawatan': idPerawatan.toString(),
      'nama_perawatan': namaPerawatan,
      'id_pegawai': idPegawai.toString(),
      'tanggal': tanggal.toString(),
      'jam': jam.toString(),
      'total': total
    },
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to get snap token');
  }
}
