class UserModel {
  String? id;
  String? email;
  String? avatar;
  String? nama;
  String? role;
  String? status;
  String? nomorTelepon;

  UserModel(
      {this.id,
      this.email,
      this.avatar,
      this.nama,
      this.role,
      this.status,
      this.nomorTelepon});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    avatar = json['avatar'];
    nama = json['nama'];
    role = json['role'];
    status = json['status'];
    nomorTelepon = json['nomor_telepon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['nama'] = this.nama;
    data['role'] = this.role;
    data['status'] = this.status;
    data['status'] = this.nomorTelepon;
    return data;
  }
}
