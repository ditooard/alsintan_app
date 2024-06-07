import 'package:flutter/material.dart';

class DaftarUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Text(
              "Daftar User Page"
            )
          ),
        ),
      ),
    );
  }
}
