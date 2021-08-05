import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:users_post/widgets/WidgetHomeBaseDesign.dart';

class ScreenAccount extends StatefulWidget {
  @override
  _ScreenAccountState createState() => _ScreenAccountState();
}

class _ScreenAccountState extends State<ScreenAccount> {
  File _image;

  @override
  Widget build(BuildContext context) {
    return WidgetHomeBaseDesign(
      marginToBody:
          EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
      widgetBody: Container(
        margin: EdgeInsets.only(top: 15),
        child: Column(
          children: [
            Card(
              elevation: 6,
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widgetTitle('Name : '),
                    widgetSubTitle('Demo User'),
                    widgetTitle('Email : '),
                    widgetSubTitle('demo@gmail.com'),
                    widgetTitle('Gender : '),
                    widgetSubTitle('Male'),
                    widgetTitle('Status : '),
                    widgetSubTitle('Active'),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      widgetTop: Container(
        padding: EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                (_image == null)
                    ? CircleAvatar(
                        backgroundColor: Color.fromRGBO(242, 242, 242, 1),
                        radius: 48,
                        child: IconButton(
                          icon: Icon(
                            CupertinoIcons.person_circle,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            _showPicker(context);
                          },
                        ),
                      )
                    : GestureDetector(
                        onLongPress: () {
                          _showPicker(context);
                        },
                        child: CircleAvatar(
                          radius: 48,
                          backgroundImage: Image.file(_image).image,
                        ),
                      ),
                Positioned(
                  child: GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 15,
                      child: Center(
                        child: Icon(
                          CupertinoIcons.camera,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget widgetTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        '$title',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget widgetSubTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        '$title',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Gallery'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _imgFromCamera() async {
    var tempImage = await ImagePicker().getImage(source: ImageSource.camera);

    setState(() {
      _image = File(tempImage.path);
    });
  }

  _imgFromGallery() async {
    var tempImage = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(tempImage.path);
    });
  }
}
