import 'dart:convert';
import 'dart:io';

import 'package:alsintan_app/services/myserverconfig.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

class TambahAlsintan extends StatefulWidget {
  @override
  State<TambahAlsintan> createState() => _TambahAlsintan();
}

class _TambahAlsintan extends State<TambahAlsintan> {
  late double screenWidth, screenHeight;

  File? _image;

  FocusNode _pemilikAlsintan = FocusNode();
  FocusNode _kelompokTani = FocusNode();
  FocusNode _profesiPemilik = FocusNode();
  FocusNode _profesiSampingan = FocusNode();
  FocusNode _merkAlsintan = FocusNode();
  FocusNode _asalAlsintan = FocusNode();
  FocusNode _pertamaPenggunaan = FocusNode();
  FocusNode _terakhirPenggunaan = FocusNode();
  FocusNode __daerahPenggunaan = FocusNode();
  FocusNode _waktuOperasional = FocusNode();
  FocusNode _perawatanHarian = FocusNode();
  FocusNode _tempatPembelianSukuCadang = FocusNode();
  FocusNode _pendanaanPerawatan = FocusNode();
  FocusNode _tempatPembelianBahanBakar = FocusNode();
  FocusNode _kendalaPerawatan = FocusNode();
  FocusNode _terakhirService = FocusNode();
  FocusNode _bengkelTerdekat = FocusNode();
  FocusNode _bengkelTerdekatPerawatan = FocusNode();
  FocusNode _tanggapanUser = FocusNode();
  FocusNode _daerahPenggunaan = FocusNode();

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
  }

  Future<void> tambahAlsintan(BuildContext context) async {
    String pa = _pemilikAlsintanController.text;
    String kt = _kelompokTaniController.text;
    String pp = _profesiPemilikController.text;
    String ps = _profesiSampinganController.text;
    String ma = _merkAlsintanController.text;
    String aa = _asalAlsintanController.text;
    String pertamaP = _pertamaPenggunaanController.text;
    String tp = _terakhirPenggunaanController.text;
    String dp = _daerahPenggunaanController.text;
    String wo = _waktuOperasionalController.text;
    String ph = _perawatanHarianController.text;
    String tpsc = _tempatPembelianSukuCadangController.text;
    String pendanaanP = _pendanaanPerawatanController.text;
    String tempatP = _tempatPembelianBahanBakarController.text;
    String kp = _kendalaPerawatanController.text;
    String ts = _terakhirServiceController.text;
    String bt = _bengkelTerdekatController.text;
    String btp = _bengkelTerdekatPerawatanController.text;
    String tu = _tanggapanUserController.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Token not found in SharedPreferences"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("No image selected"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${MyServerConfig.server}/pengguna/store-alsintan"),
      );

      request.headers['Authorization'] = 'Bearer $token';

      request.fields['nama_pemilik'] = pa;
      request.fields['kelompok_tani'] = kt;
      request.fields['profesi_pemilik'] = pp;
      request.fields['profesi_sampingan_pemilik'] = ps;
      request.fields['merk'] = ma;
      request.fields['asal_alsintan'] = aa;
      request.fields['pertama_pengguna_operasional'] = pertamaP;
      request.fields['terahir_pengguna_operasional'] = tp;
      request.fields['daerah_penggunaan_operasional'] = dp;
      request.fields['waktu_operasional_sekali_pakai'] = wo;
      request.fields['perawatan_harian'] = ph;
      request.fields['tempat_pembelian_suku_cadang'] = tpsc;
      request.fields['pendanaan_perawatan'] = pendanaanP;
      request.fields['tempat_pembelian_bahan_bakar'] = tempatP;
      request.fields['kendala_perawatan'] = kp;
      request.fields['terahir_service'] = ts;
      request.fields['bengkel_terdekat'] = bt;
      request.fields['bengkel_terdekat_perawatan'] = btp;
      request.fields['tanggapan_user_untuk_alsintan'] = tu;

      var stream = http.ByteStream(_image!.openRead());
      var length = await _image!.length();
      var multipartFile = http.MultipartFile(
        'image',
        stream,
        length,
        filename: basename(_image!.path),
        contentType:
            MediaType('image', 'jpeg'), // Sesuaikan dengan tipe file Anda
      );

      request.files.add(multipartFile);

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await http.Response.fromStream(response);
        print("Response body: ${responseBody.body}");

        try {
          var jsonData = jsonDecode(responseBody.body);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Tambah Alsintan Berhasil."),
            backgroundColor: Colors.green,
          ));
          Navigator.pushReplacementNamed(context, '/landingPageUser');
        } catch (e) {
          print("Error decoding JSON: $e");
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Insert Failed. Error decoding JSON"),
            backgroundColor: Colors.red,
          ));
        }
      } else if (response.statusCode == 422) {
        // Handle HTTP 422 Unprocessable Entity error
        var responseBody = await http.Response.fromStream(response);
        print("HTTP Error 422: ${responseBody.body}");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Insert Failed. Data validation error"),
          backgroundColor: Colors.red,
        ));
      } else {
        // Handle other HTTP errors
        print("HTTP Error: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Insert Failed. HTTP Error"),
          backgroundColor: Colors.red,
        ));
      }
    } catch (error) {
      // Handle request error
      print("Error during HTTP request: $error");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Insert Failed. Error during request"),
        backgroundColor: Colors.red,
      ));
    }
  }

  void dispose() {
    _pemilikAlsintan.dispose();
    _kelompokTani.dispose();
    _profesiPemilik.dispose();
    _profesiSampingan.dispose();
    _merkAlsintan.dispose();
    _asalAlsintan.dispose();
    _pertamaPenggunaan.dispose();
    _terakhirPenggunaan.dispose();
    __daerahPenggunaan.dispose();
    _waktuOperasional.dispose();
    _perawatanHarian.dispose();
    _tempatPembelianSukuCadang.dispose();
    _pendanaanPerawatan.dispose();
    _tempatPembelianBahanBakar.dispose();
    _kendalaPerawatan.dispose();
    _terakhirService.dispose();
    _bengkelTerdekat.dispose();
    _bengkelTerdekatPerawatan.dispose();
    _tanggapanUser.dispose();
    _daerahPenggunaan.dispose();

    super.dispose();
  }

  void showSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Select from",
              style: TextStyle(),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(screenWidth / 4, screenHeight / 8)),
                  child: const Text('Gallery'),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    _selectfromGallery(),
                  },
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(screenWidth / 4, screenHeight / 8)),
                  child: const Text('Camera'),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    _selectFromCamera(),
                  },
                ),
              ],
            ));
      },
    );
  }

  Future<void> _selectfromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
      imageQuality: 10, // Adjust quality here (0-100)
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    } else {
      print('No image selected.');
    }
  }

  Future<void> _selectFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
      imageQuality: 10, // Adjust quality here (0-100)
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);

      cropImage();
    } else {
      print('No image selected.');
    }
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio4x3,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Please Crop Your Image',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
          minimumAspectRatio: 1.0,
        ),
      ],
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 80,
    );

    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      print('Cropped image path: ${imageFile.path}');
      print('Cropped image size: ${imageFile.lengthSync()} bytes');
      setState(() {});
    }
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
      bottomNavigationBar: BottomAppBar(
        elevation: 100,
        color: Color(0xFFFFFFFF), // Change background color
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: ElevatedButton(
            onPressed: () {
              tambahAlsintan(context);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(200, 50), // Adjust size as needed
              padding: EdgeInsets.all(0), // No padding
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
                        'Tambah Alsintan',
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
                      Container(
                        padding: const EdgeInsets.fromLTRB(35, 8, 8, 8),
                        child: GestureDetector(
                          onTap: () {
                            showSelectionDialog(context);
                          },
                          child: Container(
                            height: screenHeight * 0.3,
                            width: screenWidth * 0.8,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.scaleDown,
                                image: _image == null
                                    ? AssetImage("assets/images/camera.png")
                                    : FileImage(_image!)
                                        as ImageProvider<Object>,
                              ),
                            ),
                          ),
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
                              child: TextField(
                                controller: _pemilikAlsintanController,
                                focusNode: _pemilikAlsintan,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (term) {
                                  _fieldFocusChange(
                                      context, _pemilikAlsintan, _kelompokTani);
                                },
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
                              child: TextField(
                                controller: _kelompokTaniController,
                                focusNode: _kelompokTani,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (term) {
                                  _fieldFocusChange(
                                      context, _kelompokTani, _profesiPemilik);
                                },
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
                              child: TextField(
                                controller: _profesiPemilikController,
                                focusNode: _profesiPemilik,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (term) {
                                  _fieldFocusChange(context, _profesiPemilik,
                                      _profesiSampingan);
                                },
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
                              child: TextField(
                                controller: _profesiSampinganController,
                                focusNode: _profesiSampingan,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (term) {
                                  _fieldFocusChange(context, _profesiSampingan,
                                      _merkAlsintan);
                                },
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
                              child: TextField(
                                controller: _merkAlsintanController,
                                focusNode: _merkAlsintan,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (term) {
                                  _fieldFocusChange(
                                      context, _merkAlsintan, _asalAlsintan);
                                },
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
                              child: TextField(
                                controller: _asalAlsintanController,
                                focusNode: _asalAlsintan,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (term) {
                                  _fieldFocusChange(context, _asalAlsintan,
                                      _pertamaPenggunaan);
                                },
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
                              child: TextField(
                                controller: _pertamaPenggunaanController,
                                focusNode: _pertamaPenggunaan,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (term) {
                                  _fieldFocusChange(context, _pertamaPenggunaan,
                                      _terakhirPenggunaan);
                                },
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
                              child: TextField(
                                controller: _terakhirPenggunaanController,
                                focusNode: _terakhirPenggunaan,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (term) {
                                  _fieldFocusChange(context,
                                      _terakhirPenggunaan, _daerahPenggunaan);
                                },
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
                              child: TextField(
                                controller: _daerahPenggunaanController,
                                focusNode: _daerahPenggunaan,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (term) {
                                  _fieldFocusChange(context, _daerahPenggunaan,
                                      _waktuOperasional);
                                },
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
                              child: TextField(
                                controller: _waktuOperasionalController,
                                focusNode: _waktuOperasional,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (term) {
                                  _fieldFocusChange(context, _waktuOperasional,
                                      _perawatanHarian);
                                },
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
                              child: TextField(
                                controller: _perawatanHarianController,
                                focusNode: _perawatanHarian,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (term) {
                                  _fieldFocusChange(context, _perawatanHarian,
                                      _tempatPembelianSukuCadang);
                                },
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
                              child: TextField(
                                controller:
                                    _tempatPembelianSukuCadangController,
                                focusNode: _tempatPembelianSukuCadang,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (term) {
                                  _fieldFocusChange(
                                      context,
                                      _tempatPembelianSukuCadang,
                                      _pendanaanPerawatan);
                                },
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
                              child: TextField(
                                controller: _pendanaanPerawatanController,
                                focusNode: _pendanaanPerawatan,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (term) {
                                  _fieldFocusChange(
                                      context,
                                      _pendanaanPerawatan,
                                      _tempatPembelianBahanBakar);
                                },
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
                              child: TextField(
                                controller:
                                    _tempatPembelianBahanBakarController,
                                focusNode: _tempatPembelianBahanBakar,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (term) {
                                  _fieldFocusChange(
                                      context,
                                      _tempatPembelianBahanBakar,
                                      _kendalaPerawatan);
                                },
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
                              child: TextField(
                                controller: _kendalaPerawatanController,
                                focusNode: _kendalaPerawatan,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (term) {
                                  _fieldFocusChange(context, _kendalaPerawatan,
                                      _terakhirService);
                                },
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
                              child: TextField(
                                controller: _terakhirServiceController,
                                focusNode: _terakhirService,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (term) {
                                  _fieldFocusChange(context, _terakhirService,
                                      _bengkelTerdekat);
                                },
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
                              child: TextField(
                                controller: _bengkelTerdekatPerawatanController,
                                focusNode: _bengkelTerdekat,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (term) {
                                  _fieldFocusChange(context, _bengkelTerdekat,
                                      _bengkelTerdekatPerawatan);
                                },
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
                              child: TextField(
                                controller: _bengkelTerdekatController,
                                focusNode: _bengkelTerdekatPerawatan,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (term) {
                                  _fieldFocusChange(
                                      context,
                                      _bengkelTerdekatPerawatan,
                                      _tanggapanUser);
                                },
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
                              child: TextField(
                                controller: _tanggapanUserController,
                                focusNode: _tanggapanUser,
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
