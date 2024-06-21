
class Alsinta {
  final int id;
  final String namaPemilik;
  final String kelompokTani;
  final String profesiPemilik;
  final String profesiSampinganPemilik;
  final String merk;
  final String asalAlsintan;
  final String pertamaPenggunaOperasional;
  final String terahirPenggunaOperasional;
  final String daerahPenggunaanOperasional;
  final String waktuOperasionalSekaliPakai;
  final String perawatanHarian;
  final String tempatPembelianSukuCadang;
  final String pendanaanPerawatan;
  final String tempatPembelianBahanBakar;
  final String kendalaPerawatan;
  final String terahirService;
  final String bengkelTerdekat;
  final String bengkelTerdekatPerawatan;
  final String tanggapanUserUntukAlsintan;
  final String image;
  final String urlQr;
  final DateTime createdAt;
  final DateTime updatedAt;

  Alsinta({
    required this.id,
    required this.namaPemilik,
    required this.kelompokTani,
    required this.profesiPemilik,
    required this.profesiSampinganPemilik,
    required this.merk,
    required this.asalAlsintan,
    required this.pertamaPenggunaOperasional,
    required this.terahirPenggunaOperasional,
    required this.daerahPenggunaanOperasional,
    required this.waktuOperasionalSekaliPakai,
    required this.perawatanHarian,
    required this.tempatPembelianSukuCadang,
    required this.pendanaanPerawatan,
    required this.tempatPembelianBahanBakar,
    required this.kendalaPerawatan,
    required this.terahirService,
    required this.bengkelTerdekat,
    required this.bengkelTerdekatPerawatan,
    required this.tanggapanUserUntukAlsintan,
    required this.image,
    required this.urlQr,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Alsinta.fromJson(Map<String, dynamic> json) {
    return Alsinta(
      id: json['id'],
      namaPemilik: json['nama_pemilik'],
      kelompokTani: json['kelompok_tani'],
      profesiPemilik: json['profesi_pemilik'],
      profesiSampinganPemilik: json['profesi_sampingan_pemilik'],
      merk: json['merk'],
      asalAlsintan: json['asal_alsintan'],
      pertamaPenggunaOperasional: json['pertama_pengguna_operasional'],
      terahirPenggunaOperasional: json['terahir_pengguna_operasional'],
      daerahPenggunaanOperasional: json['daerah_penggunaan_operasional'],
      waktuOperasionalSekaliPakai: json['waktu_operasional_sekali_pakai'],
      perawatanHarian: json['perawatan_harian'],
      tempatPembelianSukuCadang: json['tempat_pembelian_suku_cadang'],
      pendanaanPerawatan: json['pendanaan_perawatan'],
      tempatPembelianBahanBakar: json['tempat_pembelian_bahan_bakar'],
      kendalaPerawatan: json['kendala_perawatan'],
      terahirService: json['terahir_service'],
      bengkelTerdekat: json['bengkel_terdekat'],
      bengkelTerdekatPerawatan: json['bengkel_terdekat_perawatan'],
      tanggapanUserUntukAlsintan: json['tanggapan_user_untuk_alsintan'],
      image: json['image'],
      urlQr: json['url_qr'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
