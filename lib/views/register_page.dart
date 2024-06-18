import 'dart:convert';

import 'package:alsintan_app/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:alsintan_app/shared/loading.dart';

import '../services/myserverconfig.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  final TextEditingController _namaLengkapController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  FocusNode _namaLengkap = FocusNode();
  FocusNode _noHp = FocusNode();
  FocusNode _pass = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _registerUser(BuildContext context) {
    setState(() {
      _isLoading = true; // Set loading menjadi true saat fungsi dimulai
    });

    String _namaLengkap = _namaLengkapController.text;
    String _noHp = _noHpController.text;
    String _pass = _passController.text;

    var body = jsonEncode({
      "nama_lengkap": "$_namaLengkap",
      "no_hp": "$_noHp",
      "password": "$_pass"
    });

    http
        .post(Uri.parse("${MyServerConfig.server}/pengguna/register"),
            headers: {"Content-Type": "application/json"}, body: body)
        .then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Register Success"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (content) => LoginPage(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Pembuatan Akun Gagal. Mohon koreksi kembali"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double lebarLayar = MediaQuery.of(context).size.width;
    double tinggiLayar = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
              child: Container(
            width: lebarLayar,
            height: 800,
            padding: const EdgeInsets.only(
              top: 80,
              left: 55,
              right: 40,
            ),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 307,
                  height: 87,
                  child: Text(
                    'Buat Akun ! \nKelola Alsintan-mu !',
                    style: TextStyle(
                      color: Color(0xFF1E1349),
                      fontSize: 28,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Container(
                  width: 292,
                  height: 580,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 287,
                          height: 75.39,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 24.82,
                                child: Container(
                                  width: 287,
                                  height: 52,
                                  child: TextFormField(
                                    controller: _namaLengkapController,
                                    focusNode: _namaLengkap,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (term) {
                                      _fieldFocusChange(
                                          context, _namaLengkap, _noHp);
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Masukan Nama Anda",
                                      hintStyle: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                      contentPadding:
                                          EdgeInsets.only(top: 0, left: 20),
                                      // Sesuaikan angka ini sesuai kebutuhan Anda
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFDBD7EB)),
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                child: SizedBox(
                                  width: 268,
                                  height: 19.31,
                                  child: Text(
                                    'Nama Lengkap',
                                    style: TextStyle(
                                      color: Color(0xFF1E1349),
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 90,
                        child: Container(
                          width: 287,
                          height: 75.39,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 24.82,
                                child: Container(
                                  width: 287,
                                  height: 52,
                                  child: TextFormField(
                                    controller: _noHpController,
                                    focusNode: _noHp,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (term) {
                                      _fieldFocusChange(context, _noHp, _pass);
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Masukan Nomor Handphone anda",
                                      hintStyle: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                      contentPadding:
                                          EdgeInsets.only(top: 0, left: 20),
                                      // Sesuaikan angka ini sesuai kebutuhan Anda
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFDBD7EB)),
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                child: SizedBox(
                                  width: 268,
                                  height: 19.31,
                                  child: Text(
                                    'No Handphone',
                                    style: TextStyle(
                                      color: Color(0xFF1E1349),
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 180,
                        child: Container(
                          width: 287,
                          height: 75.39,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 24.82,
                                child: Container(
                                  width: 287,
                                  height: 52,
                                  child: TextFormField(
                                    controller: _passController,
                                    focusNode: _pass,
                                    textInputAction: TextInputAction.next,

                                    validator: (val) =>
                                        val!.isEmpty || (val.length < 3)
                                            ? "Please enter password"
                                            : null,
                                    obscureText:
                                        !_isPasswordVisible, // This hides the entered text as dots for a password field
                                    decoration: InputDecoration(
                                      hintText: "Masukan Password Anda",
                                      hintStyle: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                      contentPadding:
                                          EdgeInsets.only(top: 0, left: 20),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFDBD7EB)),
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey, // Warna ikon mata
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isPasswordVisible =
                                                !_isPasswordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                child: SizedBox(
                                  width: 268,
                                  height: 19.31,
                                  child: Text(
                                    'Password',
                                    style: TextStyle(
                                      color: Color(0xFF1E1349),
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 300,
                        child: Container(
                          width: 287,
                          height: 50.57,
                          child: _isLoading
                              ? LoadingIndicator()
                              : ElevatedButton(
                                  onPressed: () {
                                    _registerUser(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary:
                                        Color(0xFF31C48D), // Background color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(17),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.87),
                                    child: Text(
                                      'Ayo Mulai !',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                        left: 35,
                        top: 390,
                        child: SizedBox(
                          width: 311,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Sudah Memiliki Akun? ',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 12,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Login Sekarang',
                                    style: TextStyle(
                                      color: Color(0xFF31C48D),
                                      fontSize: 12,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 63,
                        top: 600,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/termsConditions');
                          },
                          child: Text(
                            'Terms and Conditions',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF31C48D),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w300,
                              decoration: TextDecoration.underline,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
