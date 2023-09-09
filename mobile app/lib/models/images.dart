class Images {
  int? id;
  String? image;
  String? title;

  Images({
    this.id,
    this.image,
    this.title,
  });

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(id: json['id'], image: json['image'], title: json['title']);
  }

  factory Images.fromMap(Map<String, dynamic> map) {
    return Images(
      id: map['id'],
      image: map['image'],
      title: map['title'],
    );
  }
}
