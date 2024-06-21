class DbResponse {
  final int status;
  final String message;
  final int totalAlsintan;
  final int totalUser;

  DbResponse({
    required this.status,
    required this.message,
    required this.totalAlsintan,
    required this.totalUser,
  });

  factory DbResponse.fromJson(Map<String, dynamic> json) {
    return DbResponse(
      status: json['status'],
      message: json['message'],
      totalAlsintan: json['total alsintan'], // Jika ada spasi, ganti dengan totalAlsintan: json['total alsintan']
      totalUser: json['total user'], // Jika ada spasi, ganti dengan totalUser: json['total user']
    );
  }
}
