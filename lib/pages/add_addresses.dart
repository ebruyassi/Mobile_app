// ignore_for_file: avoid_print
import 'package:bitirme_prejem/models/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bitirme_prejem/AppAndBottom/appbar.dart';
import 'package:bitirme_prejem/AppAndBottom/bottom_menu.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController tittleController = TextEditingController();
  TextEditingController fulladdressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBarMenu(),
            body: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          'Adres Adı:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Lütfen adres adını giriniz.';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-z A-Z]")),
                          ],
                          controller: tittleController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                borderSide: BorderSide(
                                    color:
                                        ThemeText.themColor.withOpacity(0.5))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                borderSide:
                                    BorderSide(color: ThemeText.themColor)),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                            hintText: 'Ev',
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          'Adres:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Lütfen adres bilgisini girniz.';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-z A-Z 0-9]")),
                          ],
                          controller: fulladdressController,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  borderSide: BorderSide(
                                      color: ThemeText.themColor
                                          .withOpacity(0.5))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  borderSide:
                                      BorderSide(color: ThemeText.themColor)),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        ThemeText.themColor.withOpacity(0.3)),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(50)),
                              ),
                              hintText:
                                  'Mevlana Cad. Sümbül Sokak Beyoğlu/İstanbul'),
                        ),
                      ),
                      //Adres verileri firebase'e kayıt ediliyor.
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
                                          color: ThemeText.themColor
                                              .withOpacity(0.5))),
                                ),
                                onPressed: () {
                                  validateAndSave();
                                },
                                child: Text(
                                  'Ekle',
                                  style: TextStyle(
                                      fontSize: 16, color: ThemeText.themColor),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: const BottomMenu(2),
          ),
        ));
  }

  void validateAndSave() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      print('Form is valid');
      var ref = DateTime.now().toString();
      Map<String, dynamic> addressData = {
        'title': tittleController.text,
        'fulladdress': fulladdressController.text,
        'user_id': auth.currentUser?.uid,
        'documentId': ref,
      };
      FirebaseFirestore.instance
          .collection('addresses')
          .doc(ref)
          .set(addressData);
      Navigator.pop(context);
    } else {
      print('Form is invalid');
    }
  }
}
