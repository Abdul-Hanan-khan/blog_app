import 'package:blog_app/home_page/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blog_app/login_screen.dart';
import 'package:blog_app/theme/colors.dart';
import 'package:blog_app/variables/variables.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'top_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  dynamic status = await FlutterSession().get('status');
  String status2 = status.toString();
  // getUserLoggedIn().then((value) => getUserById());
  runApp(
    MyApp(
      status: status2,
    ),
  );

}

// Future getUserLoggedIn() async {
//
//   dynamic getCurrentUser = await FlutterSession().get('Email');
//   Variables.userLoggedIn = getCurrentUser.toString();
//   print("Current use logged in : "+Variables.userLoggedIn);
// }
// getUserById() {
//
//   final String id = Variables.userLoggedIn;
//   final userRef = FirebaseFirestore.instance.collection('Users');
//
//   userRef.doc(id).get().then((DocumentSnapshot doc) {
//
//     Variables.first_name = (doc.data()['FirstName'].toString());
//     Variables.last_name = (doc.data()['LastName'].toString());
//     Variables.email = (doc.data()['Email'].toString());
//     Variables.password = (doc.data()['Password'].toString());
//     Variables.phone_number = (doc.data()['Phone No'].toString());
//     Variables.gender = (doc.data()['Gender'].toString());
//     Variables.disability = (doc.data()['Disability Type']).toString();
//     Variables.dob = (doc.data()['DOB']).toString();
//     Variables.nationality = (doc.data()['Nationality'].toString());
//   });
//
// }




class MyApp extends StatelessWidget {
  String status;

  MyApp({this.status});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Curved Path',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home:status=='true' ? HomePage(): LoginScreen(),
    );
  }



}
