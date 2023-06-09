class Notifikasi {
  String? title;
  String? body;
  String? createdAt;

  Notifikasi({this.title, this.body, this.createdAt});

  Notifikasi.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    data['created_at'] = this.createdAt;
    return data;
  }
}
