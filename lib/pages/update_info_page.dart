// ignore_for_file: avoid_print

import 'package:bitirme_prejem/AppAndBottom/bottom_menu.dart';
import 'package:bitirme_prejem/models/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bitirme_prejem/AppAndBottom/appbar.dart';
import 'package:bitirme_prejem/pages/profile_page.dart';
import 'package:bitirme_prejem/services/firebase_service.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class UpdateInfoPage extends StatefulWidget {
  const UpdateInfoPage({Key? key}) : super(key: key);

  @override
  State<UpdateInfoPage> createState() => _UpdateInfoPageState();
}

class _UpdateInfoPageState extends State<UpdateInfoPage> {
  FirebaseService service = FirebaseService();
  var phoneMaskFormater = MaskTextInputFormatter(mask: '#### ### ## ##');
  final FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController allergieTypeController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.white,
            appBar: const AppBarMenu(),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Lütfen adınızı giriniz.';
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("[a-z A-Z]")),
                        ],
                        controller: fNameController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide(
                                  color: ThemeText.themColor.withOpacity(0.5))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              borderSide:
                                  BorderSide(color: ThemeText.themColor)),
                          icon: Icon(
                            FontAwesomeIcons.solidUser,
                            size: 25,
                            color: ThemeText.themColor,
                          ),
                          hintText: 'Adınız',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Lütfen soyadınızı giriniz.';
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("[a-z A-Z]")),
                        ],
                        controller: lNameController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide(
                                  color: ThemeText.themColor.withOpacity(0.5))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              borderSide:
                                  BorderSide(color: ThemeText.themColor)),
                          icon: Icon(
                            FontAwesomeIcons.solidUser,
                            size: 25,
                            color: ThemeText.themColor,
                          ),
                          hintText: 'Lastname',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Lütfen mail adresinizi giriniz.';
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("[a-z A-Z 0-9 @ . _]")),
                        ],
                        controller: emailController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide(
                                  color: ThemeText.themColor.withOpacity(0.5))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              borderSide:
                                  BorderSide(color: ThemeText.themColor)),
                          icon: Icon(
                            Icons.mail,
                            size: 25,
                            color: ThemeText.themColor,
                          ),
                          hintText: 'E-mail',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Lütfen telefon numaranızı giriniz.';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        inputFormatters: [phoneMaskFormater],
                        controller: phoneNoController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide(
                                  color: ThemeText.themColor.withOpacity(0.5))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              borderSide:
                                  BorderSide(color: ThemeText.themColor)),
                          icon: Icon(
                            FontAwesomeIcons.mobile,
                            size: 25,
                            color: ThemeText.themColor,
                          ),
                          hintText: 'Telefon Numarası',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Lütfen kullanıcı bilginizi giriniz.';
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]"))
                        ],
                        controller: allergieTypeController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide(
                                  color: ThemeText.themColor.withOpacity(0.5))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              borderSide:
                                  BorderSide(color: ThemeText.themColor)),
                          icon: Icon(
                            FontAwesomeIcons.disease,
                            size: 20,
                            color: ThemeText.themColor,
                          ),
                          hintText:
                              'Kullanıcı Verisi: Vegan, Vejetaryen, Yok vb.',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: Center(
                        child: SizedBox(
                          height: 50,
                          width: 200,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shadowColor: const Color(0x00e0e0e0),
                              shape: StadiumBorder(
                                  side: BorderSide(
                                      color:
                                          ThemeText.themColor.withOpacity(0.5),
                                      width: 2)),
                            ),
                            onPressed: () {
                              validateAndSave();
                              //Kullanıcının girdiği değerler Firebase yazılıyor.
                              print("ad${fNameController.text}");
                            },
                            child: Text(
                              'Güncelle',
                              style: TextStyle(
                                  fontSize: 16, color: ThemeText.themColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: const BottomMenu(2)));
  }

  void validateAndSave() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      print('Form is valid');
      service.updateInformation(
          auth.currentUser?.uid,
          fNameController.text,
          lNameController.text,
          emailController.text,
          phoneNoController.text,
          allergieTypeController);
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const ProfilePage(),
        ),
      );
    } else {
      print('Form is invalid');
    }
  }
}
