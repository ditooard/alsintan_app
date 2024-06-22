import 'dart:convert';

import 'package:alsintan_app/services/myserverconfig.dart';
import 'package:flutter/material.dart';
import 'package:alsintan_app/models/alsinta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DetailAlsintan extends StatefulWidget {
  final Alsinta alsinta;

  DetailAlsintan({required this.alsinta});

  @override
  State<DetailAlsintan> createState() => _DetailAlsintan();
}

class _DetailAlsintan extends State<DetailAlsintan> {
  late double screenWidth, screenHeight;
  String role = ''; // Variable untuk menyimpan role dari SharedPreferences

  TextEditingController _pemilikAlsintanController = TextEditingController();
  TextEditingController _kelompokTaniController = TextEditingController();
  TextEditingController _profesiPemilikController = TextEditingController();
  TextEditingController _profesiSampinganController = TextEditingController();
  TextEditingController _merkAlsintanController = TextEditingController();
  TextEditingController _asalAlsintanController = TextEditingController();
  TextEditingController _pertamaPenggunaanController = TextEditingController();
  TextEditingController _terakhirPenggunaanController = TextEditingController();
  TextEditingController _daerahPenggunaanController = TextEditingController();
  TextEditingController _waktuOperasionalController = TextEditingController();
  TextEditingController _perawatanHarianController = TextEditingController();
  TextEditingController _tempatPembelianSukuCadangController =
      TextEditingController();
  TextEditingController _pendanaanPerawatanController = TextEditingController();
  TextEditingController _tempatPembelianBahanBakarController =
      TextEditingController();
  TextEditingController _kendalaPerawatanController = TextEditingController();
  TextEditingController _terakhirServiceController = TextEditingController();
  TextEditingController _bengkelTerdekatController = TextEditingController();
  TextEditingController _bengkelTerdekatPerawatanController =
      TextEditingController();
  TextEditingController _tanggapanUserController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadRole();
    _pemilikAlsintanController.text = widget.alsinta.namaPemilik ?? '';
    _kelompokTaniController.text = widget.alsinta.kelompokTani ?? '';
    _profesiPemilikController.text = widget.alsinta.profesiPemilik ?? '';
    _profesiSampinganController.text =
        widget.alsinta.profesiSampinganPemilik ?? '';
    _merkAlsintanController.text = widget.alsinta.merk ?? '';
    _asalAlsintanController.text = widget.alsinta.asalAlsintan ?? '';
    _pertamaPenggunaanController.text =
        widget.alsinta.pertamaPenggunaOperasional ?? '';
    _terakhirPenggunaanController.text =
        widget.alsinta.terahirPenggunaOperasional ?? '';
    _daerahPenggunaanController.text =
        widget.alsinta.daerahPenggunaanOperasional ?? '';
    _waktuOperasionalController.text =
        widget.alsinta.waktuOperasionalSekaliPakai ?? '';
    _perawatanHarianController.text = widget.alsinta.perawatanHarian ?? '';
    _tempatPembelianSukuCadangController.text =
        widget.alsinta.tempatPembelianSukuCadang ?? '';
    _pendanaanPerawatanController.text =
        widget.alsinta.pendanaanPerawatan ?? '';
    _tempatPembelianBahanBakarController.text =
        widget.alsinta.tempatPembelianBahanBakar ?? '';
    _kendalaPerawatanController.text = widget.alsinta.kendalaPerawatan ?? '';
    _terakhirServiceController.text = widget.alsinta.terahirService ?? '';
    _bengkelTerdekatController.text = widget.alsinta.bengkelTerdekat ?? '';
    _bengkelTerdekatPerawatanController.text =
        widget.alsinta.bengkelTerdekatPerawatan ?? '';
    _tanggapanUserController.text =
        widget.alsinta.tanggapanUserUntukAlsintan ?? '';
  }

  Future<void> updateAlsintan() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('access_token');

    if (savedToken == null) {
      print('No token found');
      return;
    }

    final body = jsonEncode(<String, String>{
      'nama_pemilik': _pemilikAlsintanController.text,
      'kelompok_tani': _kelompokTaniController.text,
      'profesi_pemilik': _profesiPemilikController.text,
      'profesi_sampingan_pemilik': _profesiSampinganController.text,
      'merk': _merkAlsintanController.text,
      'asal_alsintan': _asalAlsintanController.text,
      'pertama_pengguna_operasional': _pertamaPenggunaanController.text,
      'terahir_pengguna_operasional': _terakhirPenggunaanController.text,
      'daerah_penggunaan_operasional': _daerahPenggunaanController.text,
      'waktu_operasional_sekali_pakai': _waktuOperasionalController.text,
      'perawatan_harian': _perawatanHarianController.text,
      'tempat_pembelian_suku_cadang': _tempatPembelianSukuCadangController.text,
      'pendanaan_perawatan': _pendanaanPerawatanController.text,
      'tempat_pembelian_bahan_bakar': _tempatPembelianBahanBakarController.text,
      'kendala_perawatan': _kendalaPerawatanController.text,
      'terahir_service': _terakhirServiceController.text,
      'bengkel_terdekat': _bengkelTerdekatController.text,
      'bengkel_terdekat_perawatan': _bengkelTerdekatPerawatanController.text,
      'tanggapan_user_untuk_alsintan': _tanggapanUserController.text,
    });

    final response = await http.put(
      Uri.parse(
          '${MyServerConfig.server}/pengguna/update-alsintan/${widget.alsinta.id}'),
      headers: {
        'Authorization': 'Bearer $savedToken',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      // Update successful
      print('Alsintan updated successfully');
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Update Alsintan Berhasil."),
        backgroundColor: Colors.green,
      ));
      Navigator.pushReplacementNamed(context, '/landingPageUser');
      // Optionally, update local SharedPreferences here if needed
    } else {
      // Error in updating profile
      print('Failed to update profile: ${response.body}');
      // Handle error accordingly
    }
  }

  void loadRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role =
          prefs.getString('role') ?? ''; // Membaca role dari SharedPreferences
    });
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: role == 'admin'
          ? null // Jika role adalah admin, maka bottom navigation bar tidak ditampilkan
          : BottomAppBar(
              elevation: 100,
              color: Color(0xFFFFFFFF),
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: ElevatedButton(
                  onPressed: () {
                    updateAlsintan();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 50),
                    padding: EdgeInsets.all(0),
                    primary: Color(0xFF31C48D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    'Simpan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
              ),
            ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: screenWidth,
            height: 2400,
            padding: const EdgeInsets.only(top: 20),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 393,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 48,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            child: Stack(
                                              children: [
                                                Icon(
                                                  Icons.arrow_back_ios,
                                                  color: Colors.black,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Detail Alsintan',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screenHeight * 0.4,
                        width: screenWidth,
                        child: Image.network(
                          widget.alsinta.image,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(height: 25),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 375,
                              height: 28,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: Text(
                                        'Nama Pemilik Alsintan',
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 14,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _pemilikAlsintanController,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12), // Set text color
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFFDBD7EC)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 375,
                              height: 28,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: Text(
                                        'Kelompok Tani',
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 14,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _kelompokTaniController,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12), // Set text color
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFFDBD7EC)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 375,
                              height: 28,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: Text(
                                        'Profesi Pemilik',
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 14,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _profesiPemilikController,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12), // Set text color
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFFDBD7EC)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 375,
                              height: 28,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: Text(
                                        'Profesi Sampingan Pemilik',
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 14,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _profesiSampinganController,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12), // Set text color
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFFDBD7EC)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 375,
                              height: 28,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: Text(
                                        'Merk / Type Alsintan',
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 14,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _merkAlsintanController,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12), // Set text color
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFFDBD7EC)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 375,
                              height: 28,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: Text(
                                        'Asal Alsintan / Asal Bantuan Alsintan',
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 14,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _asalAlsintanController,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12), // Set text color
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFFDBD7EC)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 375,
                              height: 28,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: Text(
                                        'Pertama Pengunaan Operasional',
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 14,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _pertamaPenggunaanController,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12), // Set text color
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFFDBD7EC)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 375,
                              height: 28,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: Text(
                                        'Terakhir Penggunaan Operasional',
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 14,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _terakhirPenggunaanController,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12), // Set text color
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFFDBD7EC)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 375,
                              height: 28,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: Text(
                                        'Daerah Penggunaan Operasional',
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 14,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _daerahPenggunaanController,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12), // Set text color
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFFDBD7EC)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 375,
                              height: 28,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: Text(
                                        'Waktu Operasional Sekali Pakai',
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 14,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _waktuOperasionalController,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12), // Set text color
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFFDBD7EC)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 375,
                              height: 28,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: Text(
                                        'Perawatan Harian',
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 14,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _perawatanHarianController,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12), // Set text color
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFFDBD7EC)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 375,
                              height: 28,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: Text(
                                        'Tempat Pembelian Suku Cadang',
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 14,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller:
                                    _tempatPembelianSukuCadangController,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12), // Set text color
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFFDBD7EC)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 375,
                              height: 28,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: Text(
                                        'Pendanaan Perawatan',
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 14,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _pendanaanPerawatanController,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12), // Set text color
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFFDBD7EC)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 375,
                              height: 28,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: Text(
                                        'Tempat Pembelian Bahan Bakar',
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 14,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: TextFormField(
                                controller:
                                    _tempatPembelianBahanBakarController,
                                textInputAction: TextInputAction.next,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12), // Set text color
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFFDBD7EC)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 375,
                              height: 28,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: Text(
                                        'Kendala Perawatan',
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 14,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _kendalaPerawatanController,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12), // Set text color
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFFDBD7EC)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 375,
                              height: 28,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: Text(
                                        'Terakhir Service',
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 14,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _terakhirServiceController,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12), // Set text color
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFFDBD7EC)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 375,
                              height: 28,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: Text(
                                        'Bengkel Terdekat',
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 14,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _bengkelTerdekatController,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12), // Set text color
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFFDBD7EC)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 375,
                              height: 28,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: Text(
                                        'Bengkel Terdekat Perawatan',
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 14,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _bengkelTerdekatPerawatanController,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12), // Set text color
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFFDBD7EC)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 375,
                              height: 28,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: Text(
                                        'Tanggapan User untuk Alsintan',
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 14,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _tanggapanUserController,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12), // Set text color
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFFDBD7EC)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
