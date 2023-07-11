import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bitirme_prejem/pages/login_page.dart';
import 'package:bitirme_prejem/pages/product_page.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  void signIn(String email, String password, context) async {
    // ignore: prefer_typing_uninitialized_variables

    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const ProductPage(),
              )));
    } on FirebaseAuthException catch (e) {
      showMessage(e.message.toString());
    }
  }

  signOut() async {
    return await _auth.signOut();
  }

  Future<void> sendCode(userEmail, context) async {
    String mesage =
        "Your password reset email has been sent. Please check your inbox.";
    try {
      await _auth
          .sendPasswordResetEmail(email: userEmail)
          .then((value) => showMessage(mesage));
    } on FirebaseAuthException catch (e) {
      showMessage(e.message.toString());
    }
  }

  void createUser(context, fname, lname, email, address, phoneNo, password,
      allergieType, birthday) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => _firebase
              .collection("Users")
              .doc(_auth.currentUser?.uid)
              .set({
                "fName": fname,
                "lName": lname,
                "email": email,
                "address": address,
                "tel_no": phoneNo,
                "allergieType": allergieType,
                "birthDay": birthday
              })
              .then((value) => showMessage("The account has been created."))
              .then((value) => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const LoginPage(),
                    ),
                  )));
    } on FirebaseAuthException catch (e) {
      showMessage(e.message.toString());
    }
  }

  showMessage(String mesage) {
    Fluttertoast.showToast(
        msg: mesage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 4,
        backgroundColor: const Color.fromARGB(255, 221, 66, 66),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
