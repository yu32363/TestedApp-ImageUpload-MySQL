import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:image_upload_test_app/const.dart';
import 'package:image_upload_test_app/show_all_image.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File _image;
  final picker = ImagePicker();
  TextEditingController nameController = TextEditingController();

  Future choiceImage() async {
    var pickedImage =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = File(pickedImage.path);
    });
  }

  Future uploadImage() async {
    final uri =
        Uri.parse("http://192.168.1.36/image_upload_php_mysql/upload.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['name'] = nameController.text;
    var pic = await http.MultipartFile.fromPath("image", _image.path);
    request.files.add(pic);
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image Uploaded');
    } else {
      print('Image Not Uploaded');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text(
          'ตรวจวัดอุณหภูมิ',
          style: kAppBarText,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: kSecondColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'รหัส: N0002',
                        ),
                        Text(
                          'ผู้ถูกตรวจ: สมชาย รักดี',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CircleAvatar(
                      backgroundColor: kMainColor,
                      child: Icon(Icons.person),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  'ตรวจวัดอุณหภูมิ',
                  style: kMenuText,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 80,
                  width: 80,
                  child: Image.asset('images/thermometer.png'),
                ),
                SizedBox(
                  height: 20,
                ),
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      color: kSecondColor,
                      height: 200,
                      width: 200,
                      child: _image == null ? Text('') : Image.file(_image),
                    ),
                    Container(
                      height: 200,
                      width: 200,
                      child: IconButton(
                        icon: Icon(
                          Icons.add_a_photo,
                          size: 50,
                        ),
                        onPressed: () {
                          choiceImage();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 150,
                      child: TextField(
                        decoration: InputDecoration(hintText: 'ระบุอุณหูมิ'),
                        textAlign: TextAlign.center,
                        controller: nameController,
                      ),
                    ),
                    Text(
                      'C',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  color: kMainColor,
                  onPressed: () {
                    uploadImage();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowAllImage(),
                      ),
                    );
                  },
                  child: Text(
                    'บันทึก',
                    style: kAppBarText,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
