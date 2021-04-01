// import 'package:flutter/material.dart';
// import 'loginRegister/LoginRegistraitonPage.dart';
// import 'home_page/HomePage.dart';
// import 'Authentication.dart';
//
// class MappingPage extends StatefulWidget {
//   final AuthImplementation auth;
//
//   MappingPage({
//     this.auth,
//   });
//
//   @override
//   _MappingPageState createState() => _MappingPageState();
// }
// enum AuthStatus {
//   notSignedIn,
//   singedIn
// }
//
//
// class _MappingPageState extends State<MappingPage> {
//   AuthStatus authStatus = AuthStatus.notSignedIn;
//
//   @override
//   void initState() {
//     super.initState();
//
//     widget.auth.getCurrentUser().then((firebaseUserId) {
//       setState(() {
//         authStatus =
//         firebaseUserId == null ? AuthStatus.notSignedIn : AuthStatus.singedIn;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//   switch(authStatus){
//     case AuthStatus.notSignedIn:
//       return new LoginResgisterPage(auth:widget.auth,);
//   }
//     return Container();
//   }
// }
