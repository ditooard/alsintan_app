import 'package:flutter/material.dart';
import 'package:alsintan_app/models/font.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DaftarAlsintan extends StatefulWidget {
  @override
  State<DaftarAlsintan> createState() => _DaftarAlsintan();
}

class _DaftarAlsintan extends State<DaftarAlsintan> {
  final List<String> alsintanNames = [
    "Traktor Roda Dua",
    "Traktor Roda Tiga",
    "Traktor Roda Empat",
    "Traktor Roda Dua",
    "Traktor Roda Tiga",
    "Traktor Roda Empat",
    "Traktor Roda Dua",
    "Traktor Roda Tiga",
    "Traktor Roda Empat"
    
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double lebarLayar = MediaQuery.of(context).size.width;
    double tinggiLayar = MediaQuery.of(context).size.height;
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.only(top: 50, bottom: 10),
          child: Text('Daftar Alsintan'),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: alsintanNames.length,
          itemBuilder: (context, index) {
            return Container(
              width: lebarLayar,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              margin: const EdgeInsets.only(bottom: 8.0),
              decoration: BoxDecoration(
                color: Color(0xFFF8F8F8),
                border: Border.all(
                  color: Color(0xFFF4F4F4),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alsintanNames[index],
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 14,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/qrcode.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
