import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:alsintan_app/services/myserverconfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alsintan_app/shared/loading.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  FocusNode _key = FocusNode();
  FocusNode _pass = FocusNode();
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  // void _login(BuildContext context) {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   String _key = _keyController.text;
  //   String _pass = _passController.text;

  //   var body = jsonEncode({"key": "$_key", "password": "$_pass"});

  //   http
  //       .post(Uri.parse("${MyServerConfig.server}/api/v1/auth/login"),
  //           headers: {"Content-Type": "application/json"}, body: body)
  //       .then((response) async {
  //     print(response.body);
  //     if (response.statusCode == 200) {
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       await prefs.setString('token', json.decode(response.body)['token']);

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text("Login Success"),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (content) => LandingPage(),
  //         ),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text("Login Gagal. Akun atau kata sandi salah!"),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   }).whenComplete(() {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  // }

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
            height: tinggiLayar,
            padding: const EdgeInsets.only(
              top: 150,
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
                    'Login \nKelola Alsintan-mu !',
                    style: TextStyle(
                      color: Color(0xFF1E1349),
                      fontSize: 28,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  width: 292,
                  height: 400,
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
                                    focusNode: _key,
                                    controller: _keyController,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (term) {
                                      _fieldFocusChange(context, _key, _pass);
                                    },
                                    decoration: InputDecoration(
                                      hintText:
                                          'Masukan Nomor Handphone',
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
                                    'Nomor Handphone',
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
                        left: 3,
                        top: 93.78,
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
                                    focusNode: _pass,
                                    controller: _passController,
                                    obscureText:
                                        !_isPasswordVisible, // This hides the entered text as dots for a password field
                                    decoration: InputDecoration(
                                      hintText: 'Masukan Password',
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
                        top: 220,
                        child: Container(
                          width: 287,
                          height: 50.57,
                          child: _isLoading
                              ? LoadingIndicator()
                              : ElevatedButton(
                                  onPressed: () {
                                    // _login(context);
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
                                      'Masuk',
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
