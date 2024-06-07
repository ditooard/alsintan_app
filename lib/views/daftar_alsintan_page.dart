import 'package:flutter/material.dart';

class DaftarAlsintan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints.expand(),
            child: Center(
              child: Text(
                "Daftar Alsintan Page",
                style: TextStyle(fontSize: 24), // Anda dapat menyesuaikan gaya teks di sini
              ),
            ),
          ),
        ),
      ),
    );
  }
}
