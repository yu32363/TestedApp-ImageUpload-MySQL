import 'package:flutter/material.dart';
import 'package:image_upload_test_app/screen/upload_srceen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UploadScreen(),
    );
  }
}
