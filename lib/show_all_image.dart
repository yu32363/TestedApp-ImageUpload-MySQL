import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:image_upload_test_app/const.dart';

class ShowAllImage extends StatefulWidget {
  @override
  _ShowAllImageState createState() => _ShowAllImageState();
}

class _ShowAllImageState extends State<ShowAllImage> {
  Future allImage() async {
    var url = "http://192.168.1.36/image_upload_php_mysql/viewall.php";
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {});
              })
        ],
        title: Text('รูปคนที่ตรวจแล้ว'),
      ),
      body: FutureBuilder(
        future: allImage(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    List list = snapshot.data;
                    return ListTile(
                      title: Container(
                        height: 150,
                        width: 150,
                        child: Image.network(
                            'http://192.168.1.36/image_upload_php_mysql/uploads/${list[index]['image']}'),
                      ),
                      subtitle: Center(
                        child: Text(
                          list[index]['name'],
                          style: kMenuText,
                        ),
                      ),
                    );
                  })
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}
