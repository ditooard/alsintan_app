import 'dart:async';

import 'package:flutter/material.dart';
import 'package:alsintan_app/shared/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      if (!_isDisposed) {
        checkAuthentication();
      }
    });
  }

  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> checkAuthentication() async {
    if (_isDisposed) return;

    final prefs = await SharedPreferences.getInstance();
    final savedToken =
        prefs.getString('access_token'); // Ubah dari 'token' ke 'access_token'
    final role = prefs.getString('role');

    if (savedToken != null && savedToken.isNotEmpty) {
      if (role == 'admin') {
        Navigator.pushReplacementNamed(context, '/landingPageAdmin');
      } else if (role == 'pengguna') {
        Navigator.pushReplacementNamed(context, '/landingPageUser');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Sesi Login Habis, silahkan Login ulang"),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/register');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greenColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/alsintan-logo.png',
                width: 172,
                height: 168,
              )
            ],
          ),
        ),
      ),
    );
  }
}
