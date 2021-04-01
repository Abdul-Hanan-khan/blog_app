import 'package:blog_app/home_page/HomePage.dart';
import 'package:blog_app/variables/variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UploadPhotoPage extends StatefulWidget {
  @override
  _UploadPhotoPageState createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  File sampleImage;
  final formKey = new GlobalKey<FormState>();
  String _myValue;
  String url;
  String userLoggedIn;
  String first_name;
  String last_name;
  int tester = 0;
  bool isLoading = false;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      tester = 2;
      print("!!!!!!!!!!!!!!!---------true-------!!!!!!!!!!!!!!");
      return true;
    } else {
      tester = 1;
      print("!!!!!!!!!!!!!!!---------false-------!!!!!!!!!!!!!!");
      return false;
    }
  }

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
    });
  }

  Future uploadStatusImage() async {
    if (validateAndSave()) {
      setState(() {
        isLoading = true;
      });
      //save image in firebase
      Reference postImageRef;
      postImageRef = FirebaseStorage.instance.ref().child("Post Images");
      // create  a unique key for each image so that same images should bot be
      // replaced
      var timeKey = new DateTime.now();
      UploadTask uploadTask;
      uploadTask =
          postImageRef.child(timeKey.toString() + "jpg").putFile(sampleImage);
      // now get the url of image and store in firebase
      var imageUrl;
      imageUrl = await (await uploadTask).ref.getDownloadURL();
      url = imageUrl.toString();
      print("Image url = " + url);
      saveToDatabase(url);
      goToHomePage();
    }
    return true;
  }

  void saveToDatabase(url) {
    var dbTimeKey = new DateTime.now();

    var formateDate = new DateFormat('MMM d, yyyy');
    var formateTime = new DateFormat('EEEE, hh:mm aaa');

    String date = formateDate.format(dbTimeKey);
    String time = formateTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data = {
      "FirstName": Variables.first_name,
      "LastName": Variables.last_name,
      "Image": url,
      "Description": _myValue,
      "Date": date,
      "Time": time,
    };

    ref.child("Posts").push().set(data);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("=============================================================  " +
        Variables.first_name);
    print("=============================================================  " +
        Variables.last_name);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Upload Image"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child:
                sampleImage == null ? Text("Select an image") : enableUpload(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: getImage,
          tooltip: "Add Image",
          child: Icon(Icons.add_a_photo),
        ),
      ),
    );
  }

  Widget enableUpload() {
    return Container(
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Image.file(
                sampleImage,
                height: 330.0,
                width: MediaQuery.of(context).size.width,
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                decoration: new InputDecoration(labelText: "Blog"),
                validator: (value) {
                  return value.isEmpty ? 'Blog description is required' : null;
                },
                onSaved: (value) {
                  return _myValue = value;
                },
              ),
              SizedBox(
                height: 15.0,
              ),
             !isLoading? RaisedButton(
                elevation: 10.0,
                child: Text("Add a new post"),
                textColor: Colors.white,
                color: Colors.pinkAccent,
                onPressed: uploadStatusImage,
                //   onPressed: goToHomePage,
              ):CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }

  void goToHomePage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("My title"),
      content: Text("This is my message."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
