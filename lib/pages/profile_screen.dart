import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wallet_blockchain/model/style.dart';
import 'package:wallet_blockchain/provider/auth.dart';
import 'package:wallet_blockchain/provider/send_ether.dart';

class ProfileSceen extends StatefulWidget {

  @override
  _ProfileSceenState createState() => _ProfileSceenState();
}

class _ProfileSceenState extends State<ProfileSceen> {
  File _image;
  final picker = ImagePicker();

  Future  getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if(pickedFile != null) {
        _image = File(pickedFile.path);
      }else{
        print('No Image selected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context);
    auth.getUser();
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Profile",
            style: TextStyle(
              color: black
            ),),
        centerTitle: true,
        backgroundColor: blueAc,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 115,
                width: 115,
                child: Center(
                  child: Stack(
                    fit: StackFit.expand,
                    overflow: Overflow.visible,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: _image == null
                            ? AssetImage("images/avatar5.png")
                            : FileImage(_image)
                      ),
                      Positioned(
                        right: -18,
                        bottom: 0,
                        child: SizedBox(
                          height: 46,
                          width: 46,
                          child: FlatButton(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: BorderSide(
                                color: greyAc
                              ),
                            ),
                            color: blueAc,
                            onPressed: () {
                              getImage();
                              if(_image!= null){
                                auth.uploadImageStorage(_image);
                                print("sf");
                              }

                            },
                            child: SvgPicture.asset("images/gallery.svg", height: 25,),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                child: Expanded(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: black,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)
                            ),
                            fillColor: blueAc,
                            labelText: "Full Name",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: auth.users.username,
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: black,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: black,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)
                            ),
                            fillColor: blueAc,
                            labelText: "Address",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: "Da Nang",
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: black,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: black,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)
                            ),
                            fillColor: blueAc,
                            labelText: "Phone Number",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: "035 976 9804",
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: blueAc,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: FlatButton(
                    onPressed: (){},
                    child: Text(
                        "Save",
                      style: TextStyle(
                        color: black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
