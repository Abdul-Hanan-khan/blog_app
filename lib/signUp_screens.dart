import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blog_app/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';

import 'home_page/HomePage.dart';
import 'login_screen.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  CollectionReference ref = FirebaseFirestore.instance.collection("Users");

  final formKey = GlobalKey<FormState>();

  bool isLoading=false;

  bool formValidationSuccess = false;

  var fNameCtr = TextEditingController();
  var lNameCtr = TextEditingController();
  var mobileNoCtr = TextEditingController();
  var emailCtr = TextEditingController();
  var passwordCtr = TextEditingController();
  var nationalityCtr = TextEditingController();
  bool valuefirst = false;
  String disabilityType;

  String birthDateInString;
  DateTime birthDate;
  bool isDateSelected;



  @override
  void initState() {
    // TODO: implement initState
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopBar(),
            SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //fname
                    Card(
                      elevation: 7,
                      margin:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 4),
                        child: TextFormField(
                          maxLines: 1,
                          controller: fNameCtr,
                          validator: firstNameValidation,
                          decoration: InputDecoration(
                              hintText: " First Name",
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.cancel_outlined),
                                onPressed: () => fNameCtr.clear(),
                              )),
                        ),
                      ),
                    ),
                    //lname
                    Card(
                      elevation: 7,
                      margin:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 4),
                        child: TextFormField(
                          controller: lNameCtr,
                          validator: lastNameValidation,
                          decoration: InputDecoration(
                              hintText: " Last Name",
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.cancel_outlined),
                                onPressed: () => lNameCtr.clear(),
                              )),
                        ),
                      ),
                    ),
                    //Gender
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        "Gender",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: Row(
                        children: <Widget>[
                          addRadioButton(0, 'Male'),
                          addRadioButton(1, 'Female'),
                          addRadioButton(2, 'Others'),
                        ],
                      ),
                    ),

                    // date of birth
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //naitonality
                    Card(
                      elevation: 7,
                      margin:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 4),
                        child: TextFormField(
                          controller: nationalityCtr,
                          validator: nationalityValidation,
                          decoration: InputDecoration(
                              hintText: " Nationality",
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.cancel_outlined),
                                onPressed: () => nationalityCtr.clear(),
                              )),
                        ),
                      ),
                    ),
                    //mobileno
                    Card(
                      elevation: 7,
                      margin:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 4),
                        child: TextFormField(
                          controller: mobileNoCtr,
                          validator: phoneNoValidation,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: " Phone #",
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.cancel_outlined),
                                onPressed: () => mobileNoCtr.clear(),
                              )),
                        ),
                      ),
                    ),

                    //email;
                    Card(
                      elevation: 7,
                      margin:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 4),
                        child: TextFormField(
                          controller: emailCtr,
                          validator: emailValidation,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: " Email",
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.cancel_outlined),
                                onPressed: () => emailCtr.clear(),
                              )),
                        ),
                      ),
                    ),
                    //passeword
                    Card(
                      elevation: 7,
                      margin:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 4),
                        child: TextFormField(
                          controller: passwordCtr,
                          validator: passwordValidation,
                          decoration: InputDecoration(
                            hintText: " Password",
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: Icon(Icons.cancel_outlined),
                              onPressed: () => passwordCtr.clear(),
                            ),
                          ),
                          obscureText: true,
                        ),
                      ),
                    ),

                    //sing-up button
                   !isLoading? Padding(
                      padding: const EdgeInsets.only(bottom: 5),
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


                                setState(() {
                                  isLoading=true;
                                });
                                userSignUp();

                              }
                              //
                            },


                            child: SizedBox(
                              width: 100,
                              height: 50,
                              child: Center(
                                child: Text(
                                  "SignUp",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ],
                      ),
                    ): Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      ),
                   // isLoading? Row(
                   //    mainAxisAlignment: MainAxisAlignment.center,
                   //    children: [
                   //      Container(
                   //        width: 50,
                   //        height: 50,
                   //        child: CircularProgressIndicator(),
                   //      ),
                   //    ],
                   //  ):Container(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "I already have an Account",
                          style: TextStyle(color: Colors.green),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.blue.withOpacity(0.7),
                                fontSize: 25),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List gender = ["Male", "Female", "Other"];

  String genderSelected;

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: gender[btnValue],
          groupValue: genderSelected,
          onChanged: (value) {
            setState(() {
              // print(value);
              genderSelected = value;
              print(genderSelected);
            });
          },
        ),
        Text(title)
      ],
    );
  }

  String firstNameValidation(String value) {
    if (value.isEmpty) {
      return 'Please Enter First Name';
    }
  }

  String lastNameValidation(String value) {
    if (value.isEmpty) {
      return 'Please Enter Last Name';
    }
  }

  String genderValidation(String value) {
    if (value.isEmpty) {
      return 'Please Select Gender';
    }
  }

  String dateValidation(String value) {
    if (value.isEmpty) {
      return 'Please Select Date of Birth';
    }
  }

  String nationalityValidation(String value) {
    if (value.isEmpty) {
      return 'Please Enter Your Nationality';
    }
  }

  String phoneNoValidation(String value) {
    if (value.length < 11 || value.isEmpty) {
      return 'In Valid Phone No';
    }
  }

  String emailValidation(String value) {
    if (!value.contains('@gmail.com')) {
      return "Invalid Email address !";
    }
  }

  String passwordValidation(String value) {
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
  }

  void clearForm() {
    fNameCtr.clear();
    lNameCtr.clear();
    nationalityCtr.clear();
    mobileNoCtr.clear();
    emailCtr.clear();
    passwordCtr.clear();
  }


  Future userSignUp() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .where('Email', isEqualTo: emailCtr.text)
        .get()
        .then((value) {
      if (value.docs.length > 0) {
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
                  content: Text("Account exists already"),
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

      } else {
        FlutterSession().set("status", true);

        ref.doc(emailCtr.text.toString()).set({
          'FirstName': fNameCtr.text.toString(),
          'LastName': lNameCtr.text.toString(),
          'Gender': genderSelected,
          'Nationality': nationalityCtr.text.toString(),
          'Phone No': mobileNoCtr.text.toString(),
          'Email': emailCtr.text.toString(),
          'Password': passwordCtr.text.toString()
        }).whenComplete(() =>{
          clearForm(),
          Navigator.push(context, MaterialPageRoute(builder: (_)=> HomePage()))
        } );

      }
    });
  }
}
