// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:io';
import 'package:bitirme_prejem/models/style.dart';
import 'package:bitirme_prejem/pages/Orders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bitirme_prejem/AppAndBottom/appbar.dart';
import 'package:bitirme_prejem/AppAndBottom/bottom_menu.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bitirme_prejem/pages/addresses_page.dart';
import 'package:bitirme_prejem/pages/info_page.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late File imageFile;
  final imagePicker = ImagePicker();

  late String downloadUrl =
      "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.iconexperience.com%2F_img%2Fv_collection_png%2F512x512%2Fshadow%2Fusers.png&f=1&nofb=1";
  @override
  void initState() {
    super.initState();
    downloadPicture();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: const AppBarMenu(),
          body: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 5.0,
                      offset: const Offset(0, 2),
                    ),
                  ]),
              child: Column(
                children: [
                  Container(
                    height: 130,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextButton(
                            onPressed: () {
                              uploadGallery(); //Profil resmini günceller.
                            },
                            child: Card(
                              elevation: 5.0,
                              shape: OvalBorder(
                                  side: BorderSide(
                                      width: 2,
                                      color: ThemeText.themColor
                                          .withOpacity(0.3))),
                              child: ClipOval(
                                  //Firebase'den profil resmi için veri gelmezse linkteki veri gösterilir.
                                  // ignore: unnecessary_null_comparison
                                  child: downloadUrl == null
                                      ? Image.network(
                                          "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.iconexperience.com%2F_img%2Fv_collection_png%2F512x512%2Fshadow%2Fusers.png&f=1&nofb=1",
                                          fit: BoxFit.cover,
                                          height: 130,
                                          width: 100,
                                        )
                                      : Image.network(
                                          //Firebade'den alınan veri gösterilir.
                                          downloadUrl,
                                          fit: BoxFit.cover,
                                          height: 130,
                                          width: 100,
                                        )),
                            ),
                          ),
                        ),
                        //Kullanıcı bilgileri profil sayfasına yazılır.
                        Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Users')
                              .where('email',
                                  isEqualTo: auth.currentUser?.email)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot doc =
                                        snapshot.data!.docs[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: Row(
                                              children: [
                                                Text(doc['fName'],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black87)),
                                                Text(' ' + doc['lName'],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black87)),
                                              ],
                                            ),
                                          ),
                                          Text(doc['email'],
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black87)),
                                        ],
                                      ),
                                    );
                                  });
                            } else {
                              return const Text(" ");
                            }
                          },
                        ))
                      ],
                    ),
                  ),
                  Column(children: [
                    Divider(
                      height: 15,
                      thickness: 2,
                      indent: 5,
                      endIndent: 5,
                      color: ThemeText.themColor.withOpacity(0.3),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                          child: Icon(
                            FontAwesomeIcons.solidUser,
                            color: ThemeText.themColor,
                            size: 22,
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        const InfoPage(),
                                  ),
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(left: 45.0),
                                child: Text(
                                  'Kullanıcı Bilgilerim',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                  textAlign: TextAlign.start,
                                ),
                              )),
                        ),
                      ],
                    ),
                    Divider(
                      height: 15,
                      thickness: 2,
                      indent: 5,
                      endIndent: 5,
                      color: ThemeText.themColor.withOpacity(0.3),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 7.0, top: 8.0),
                          child: Icon(
                            FontAwesomeIcons.locationArrow,
                            color: ThemeText.themColor,
                            size: 20,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            const AddresPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Adreslerim',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                    textAlign: TextAlign.start,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 15,
                      thickness: 2,
                      indent: 5,
                      endIndent: 5,
                      color: ThemeText.themColor.withOpacity(0.3),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 11.0, top: 8.0),
                          child: Icon(
                            FontAwesomeIcons.basketShopping,
                            color: ThemeText.themColor,
                            size: 19,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 9.0),
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              const OrderPage(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Siparişler       ',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black),
                                      textAlign: TextAlign.start,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 15,
                      thickness: 2,
                      indent: 5,
                      endIndent: 5,
                      color: ThemeText.themColor.withOpacity(0.3),
                    ),
                  ])
                ],
              ),
            ),
          ),
          bottomNavigationBar: const BottomMenu(2)),
    );
  }

  downloadPicture() async {
    try {
      String url = await FirebaseStorage.instance
          .ref()
          .child("profil")
          .child(auth.currentUser!.uid.toString())
          .child("profilResmi")
          .getDownloadURL();
      setState(() {
        downloadUrl = url;
      });
    } catch (e) {
      setState(() {
        downloadUrl =
            "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.iconexperience.com%2F_img%2Fv_collection_png%2F512x512%2Fshadow%2Fusers.png&f=1&nofb=1";
      });
    }
  }

  //Kullanıcının yüklediği profil resmi Firebase'e aktarılır.
  uploadGallery() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(image!.path);
    });

    Reference referance = FirebaseStorage.instance
        .ref()
        .child("profil")
        .child(auth.currentUser!.uid)
        .child("profilResmi");
    UploadTask yuklemeGorevi = referance.putFile(imageFile);
    String url = await (await yuklemeGorevi).ref.getDownloadURL();
    setState(() {
      downloadUrl = url;
    });
  }
}
