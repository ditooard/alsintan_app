import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF31C48D)),
        semanticsLabel: 'Loading...',
        semanticsValue: 'Loading...',
        value: null,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
