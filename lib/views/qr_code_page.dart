import 'package:alsintan_app/models/alsinta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QRCodePage extends StatefulWidget {
  final Alsinta alsinta;

  QRCodePage({required this.alsinta});

  @override
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  late String svgAsset;

  @override
  void initState() {
    super.initState();
    svgAsset = widget.alsinta.urlQr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.network(
              svgAsset,
              width: 200,
              height: 200, 
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
