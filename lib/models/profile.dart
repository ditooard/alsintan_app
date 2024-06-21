class Profile {
  int id;
  String namaLengkap;
  String noHp;
  String alamat;
  String role;
  String createdAt;
  String updatedAt;

  Profile({
    required this.id,
    required this.namaLengkap,
    required this.noHp,
    required this.alamat,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] ??
          0, // Assuming id is an int, provide a default value like 0 if null
      namaLengkap: json['nama_lengkap'] ??
          '', // Provide an empty string if nama_lengkap is null
      noHp: json['no_hp'] ?? '', // Provide an empty string if no_hp is null
      alamat: json['alamat'] ?? '', // Provide an empty string if alamat is null
      role: json['role'] ?? '', // Provide an empty string if role is null
      createdAt: json['created_at'] ??
          '', // Provide an empty string if created_at is null
      updatedAt: json['updated_at'] ??
          '', // Provide an empty string if updated_at is null
    );
  }
}
