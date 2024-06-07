import 'package:flutter/material.dart';

class DashboardUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints.expand(),
            child: Center(
              child: Text(
                "Dashboard User Page",
                style: TextStyle(fontSize: 24), // Anda dapat menyesuaikan gaya teks di sini
              ),
            ),
          ),
        ),
      ),
    );
  }
}
