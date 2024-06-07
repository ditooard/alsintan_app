import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alsintan_app/shared/custom_buttom_navigation_admin.dart';

class LandingPageAdmin extends StatelessWidget {
  const LandingPageAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Keluar dari aplikasi ketika tombol kembali ditekan.
        SystemNavigator.pop();
        return false; // Tetap kembalikan false untuk menghindari perilaku default.
      },
      child: Scaffold(
        bottomNavigationBar: CustomBottomNavigationItemAdmin(),
      ),
    );
  }
}
