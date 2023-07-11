// ignore_for_file: avoid_print
import 'package:bitirme_prejem/models/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bitirme_prejem/AppAndBottom/appbar.dart';
import 'package:bitirme_prejem/AppAndBottom/bottom_menu.dart';
import 'package:bitirme_prejem/pages/add_addresses.dart';
import 'package:bitirme_prejem/services/firebase_service.dart';

class AddresPage extends StatefulWidget {
  const AddresPage({Key? key}) : super(key: key);

  @override
  State<AddresPage> createState() => _AddresPageState();
}

class _AddresPageState extends State<AddresPage> {
  FirebaseService service = FirebaseService();
  FirebaseAuth auth = FirebaseAuth.instance;
  List addresses = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Adreslerim',
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: const AppBarMenu(),
          body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 5.0, // soften the shadow
                  spreadRadius: 5.0, //extend the shadow
                )
              ],
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            ),
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('addresses')
                  .where('user_id', isEqualTo: auth.currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        return Column(children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(doc['title'],
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.black)),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              backgroundColor:
                                                  const Color(0XFFF3E5F5),
                                              content: const Text(
                                                  'Adres bilgisini silmek istediğinize emin misiniz?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'İptal'),
                                                  child: Text(
                                                    'İptal',
                                                    style: TextStyle(
                                                        color: ThemeText
                                                            .themColor),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection('addresses')
                                                        .doc(doc['documentId'])
                                                        .delete();
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute<void>(
                                                        builder: (BuildContext
                                                                context) =>
                                                            const AddresPage(),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    'Yes',
                                                    style: TextStyle(
                                                        color: ThemeText
                                                            .themColor),
                                                  ),
                                                ),
                                              ],
                                            ));
                                  },
                                  alignment: Alignment.centerRight,
                                  icon: Icon(
                                    FontAwesomeIcons.trash,
                                    size: 15,
                                    color: ThemeText.themColor,
                                  ))
                            ],
                          ),
                          Divider(
                            height: 15,
                            thickness: 2,
                            indent: 0,
                            endIndent: 0,
                            color: ThemeText.themColor.withOpacity(0.3),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Text(
                                  "Adres: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Text(
                                    doc['fulladdress'],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 15,
                            thickness: 2,
                            indent: 0,
                            endIndent: 0,
                            color: ThemeText.themColor.withOpacity(0.3),
                          ),
                        ]);
                      });
                } else {
                  return const Text("");
                }
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddAddress()),
              )
            },
            child: Icon(
              FontAwesomeIcons.plus,
              size: 30,
              color: ThemeText.themColor,
            ),
          ),
          bottomNavigationBar: const BottomMenu(2),
        ));
  }
}
