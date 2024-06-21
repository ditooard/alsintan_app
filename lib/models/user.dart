class User {
  final int id;
  final String namaLengkap;
  final String noHp;
  final String alamat;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.namaLengkap,
    required this.noHp,
    required this.alamat,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'],
    namaLengkap: json['nama_lengkap'],
    noHp: json['no_hp'],
    alamat: json['alamat'] ?? '', // Provide an empty string as default if 'alamat' is null
    role: json['role'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );
}

}
