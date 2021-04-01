import 'dart:io';

import 'package:blog_app/topbar_login.dart';
import 'package:blog_app/variables/variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blog_app/main.dart';
import 'package:blog_app/signUp_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'home_page/HomePage.dart';
import 'main.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

   dynamic loginStatus;


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkStatus().then((value) =>  print("LOginStatus////////////////////////////////"+loginStatus.toString()));

  }

Future checkStatus()async{
   loginStatus = await FlutterSession().get("status");
}
  bool _isAuthenticating = false;
  bool _authorized = false;
  bool _secureText = true;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();



  final formKey = GlobalKey<FormState>();
  bool formValidationSuccess = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TopBarLogin(),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding:
                      // const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      const EdgeInsets.only(
                          left: 20, right: 20, top: 40, bottom: 5),
                  child: TextFormField(
                    controller: emailController,
                    autofocus: true,
                    onSaved: (String value) {},
                    validator: emailValidationMixin,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () => emailController.clear(),
                      ),
                      labelText: 'Email',
                      hintText: 'you@example.com',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: TextFormField(
                    controller: passwordController,
                    autofocus: true,
                    // enabled: false,
                    onSaved: (String value) {},
                    validator: passwordValidationMixin,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _secureText ? Icons.remove_red_eye : Icons.security,
                          color: Colors.teal,
                        ),
                        onPressed: () {
                          setState(() {
                            _secureText = !_secureText;
                          });
                        },
                      ),
                    ),
                    obscureText: _secureText,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            formKey.currentState.save();
                            formValidationSuccess = true;
                          }

                          if (formValidationSuccess == true) {
                            userLogin();
                          }

                          //
                        },
                        child: SizedBox(
                          width: 100,
                          height: 50,
                          child: Center(
                            child: Text(
                              "Login",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                        color: Colors.blue.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                    ],
                  ),
                ),



                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an Account?",
                      style: TextStyle(color: Colors.red[400]),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()));
                      },
                      child: Text(
                        "Create Now",
                        style: TextStyle(
                            color: Colors.green.withOpacity(0.7), fontSize: 20),
                      ),
                    )
                  ],
                ),
                // SizedBox(height: 20,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  String emailValidationMixin(String value) {
    if (!value.contains('@gmail.com')) {
      return "Invalid Email address !";
    }
  }

  String passwordValidationMixin(String value) {
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
  }

  Future userLogin() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .where('Email', isEqualTo: emailController.text)
        .where('Password', isEqualTo: passwordController.text)
        .get()
        .then((value) {
      if (value.docs.length > 0) {
        FlutterSession().set('userId',value.docs[0].id);
        FlutterSession().set('Email', emailController.text);
        FlutterSession().set('Password', passwordController.text);

        FlutterSession().set('status', true).then((value) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
            // emailFingerPrint=emailController.text;
            // passwordFingerPrint=passwordController.text;

            );
      } else {
        showDialog(
            barrierColor: Colors.red[100],
            context: context,
            builder: (context) {
              return Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.amber[300])),
                child: AlertDialog(
                  title: Text(
                    "Error !",
                    style: TextStyle(color: Colors.red),
                  ),
                  content: Text("Invalid Login"),
                  backgroundColor: Colors.grey[300],
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("ok"))
                  ],
                ),
              );
            });
      }
    });
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

}
