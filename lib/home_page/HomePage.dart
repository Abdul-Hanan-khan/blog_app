import 'dart:io';

import 'package:blog_app/PhotoUpload.dart';
import 'package:blog_app/login_screen.dart';
import 'package:blog_app/model/Posts.dart';
import 'package:blog_app/variables/variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';

import '../previewImage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Posts> postsList = [];
  int imageUrlIndex;
  String imageDescription;

  @override
  void initState() {
    super.initState();
    getUserLoggedIn().then((value) => getUserById());
    DatabaseReference postRef =
        FirebaseDatabase.instance.reference().child("Posts");
    postRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;
      postsList.clear();
      for (var individualKey in KEYS) {
        Posts posts = new Posts(
          DATA[individualKey]['Image'],
          DATA[individualKey]['Description'],
          DATA[individualKey]['Date'],
          DATA[individualKey]['Time'],
          DATA[individualKey]['FirstName'],
          DATA[individualKey]['LastName'],
        );

        postsList.add(posts);
        int length = postsList.length;

        setState(() {
          print('Length : $length');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: new Text("Home "),
          backgroundColor: Colors.teal,
        ),
        body: new Container(
            child: postsList.length == 0
                ? Center(child: new Text("Loading..."))
                :
            new ListView.builder(
                itemCount: postsList.length,
                itemBuilder: (context, index) {
                  imageUrlIndex = index;
                  return PostsUI(
                      postsList[index].Image,
                      postsList[index].Description,
                      postsList[index].Date,
                      postsList[index].Time,
                      postsList[index].FirstName,
                      postsList[index].LastName);
                })),
        bottomNavigationBar: new BottomAppBar(
          color: Colors.teal[300],
          child: new Container(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      new IconButton(
                          icon: new Icon(
                            Icons.logout,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: _logoutUser),
                      Text(
                        "Logout",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      new IconButton(
                          icon: new Icon(
                            Icons.add_a_photo,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UploadPhotoPage()));
                          }),
                      Text(
                        "Post a Blog",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget PostsUI(
    String Image,
    String Description,
    String Date,
    String Time,
    String FirstName,
    String LastName,
  ) {
    return new Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),
      child: new Container(
        padding: EdgeInsets.all(14.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://th.bing.com/th/id/OIP.IuK0P9Tbazr_-U6hfXMwCgHaFj?w=239&h=180&c=7&o=5&dpr=1.09&pid=1.7'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(FirstName+" "+LastName,style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),),
                       Text(
                        Date,
                        style: TextStyle(
                          fontSize: 11
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[

                new Text(
                  Time,
                  style:TextStyle(
                    color: Colors.grey
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(Image),
              )),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(15)
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(" Blog ",style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  // backgroundColor: Colors.orange
                ),),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: new Text(
                Description,
                style: Theme.of(context).textTheme.subtitle1,

              ),
            )
          ],
        ),
      ),
    );
  }

  Future _logoutUser() async {
    await FlutterSession().set('status', false);
    Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
  }

  Future<bool> onWillPop() {
    return showDialog(
          barrierColor: Colors.blue.withOpacity(0.4),
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Icon(
                    Icons.add_alert,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Are you sure?',
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
              ],
            ),
            content: Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Text(
                'Do you want to exit.',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No', style: TextStyle(color: Colors.blue)),
              ),
              FlatButton(
                onPressed: () => exit(0),
                child: Text('Yes', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;
  }







Future getUserLoggedIn() async {

  dynamic getCurrentUser = await FlutterSession().get('Email');
  Variables.userLoggedIn = getCurrentUser.toString();
  print("Current use logged in ::::::::::::::::::::::::::::::::::::::::::::: "+Variables.userLoggedIn);
}
getUserById() {

  final String id = Variables.userLoggedIn;
  final userRef = FirebaseFirestore.instance.collection('Users');

  userRef.doc(id).get().then((DocumentSnapshot doc) {

    Variables.first_name = (doc.data()['FirstName'].toString());
    Variables.last_name = (doc.data()['LastName'].toString());
    Variables.email = (doc.data()['Email'].toString());
    Variables.password = (doc.data()['Password'].toString());
    Variables.phone_number = (doc.data()['Phone No'].toString());
    Variables.gender = (doc.data()['Gender'].toString());
    Variables.disability = (doc.data()['Disability Type']).toString();
    Variables.dob = (doc.data()['DOB']).toString();
    Variables.nationality = (doc.data()['Nationality'].toString());
  });

}

}
