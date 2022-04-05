class Provinsi {
  int? id;
  String? nama;

  Provinsi({
    required this.id,
    required this.nama,
  });

  factory Provinsi.fromJson(Map<String, dynamic> json) => Provinsi(
        id: json["id"],
        nama: json["nama"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": nama,
      };
}
