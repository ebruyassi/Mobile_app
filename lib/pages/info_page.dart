import 'package:bitirme_prejem/models/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bitirme_prejem/AppAndBottom/appbar.dart';
import 'package:bitirme_prejem/AppAndBottom/bottom_menu.dart';
import 'package:bitirme_prejem/pages/update_info_page.dart';
import 'package:bitirme_prejem/services/firebase_service.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseService service = FirebaseService();
  List info = [];

  //Kullanıcı bilgileri List'e yazılıyor.
  void fetchUserInfo() async {
    var res = await service.getUserInfo(auth.currentUser?.email);
    if (res.isEmpty) {
      // ignore: avoid_print
      print("Veri yok");
    } else {
      setState(() {
        info = res;
      });
    }
  }

  @override

  // ignore: must_call_super
  void initState() {
    fetchUserInfo();
  }

  //Kullanıcı bilgileri yazılıyor.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'User Information',
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBarMenu(),
          body: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: ThemeText.themColor.withOpacity(0.3),
                      blurRadius: 5.0,
                      offset: const Offset(0, 2),
                    ),
                  ]),
              child: Column(
                  children: info
                      .map((data) => ListView(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      const Text('Ad: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black87)),
                                      Text(" ${data.fName}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87)),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 15,
                                  thickness: 2,
                                  indent: 5,
                                  endIndent: 5,
                                  color: ThemeText.themColor.withOpacity(0.3),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      const Text('Soyad: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black87)),
                                      Text(" ${data.lName}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87)),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 15,
                                  thickness: 2,
                                  indent: 5,
                                  endIndent: 5,
                                  color: ThemeText.themColor.withOpacity(0.3),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      const Text('E-mail: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black87)),
                                      Text(" ${data.email}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87)),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 15,
                                  thickness: 2,
                                  indent: 5,
                                  endIndent: 5,
                                  color: ThemeText.themColor.withOpacity(0.3),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      const Text('Telefon Numarası: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black87)),
                                      Text(" ${data.telNo}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87)),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 15,
                                  thickness: 2,
                                  indent: 5,
                                  endIndent: 5,
                                  color: ThemeText.themColor.withOpacity(0.3),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      const Text('Kullanıcı Bilgisi: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black87)),
                                      Text(" ${data.allergieType}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87)),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 15,
                                  thickness: 2,
                                  indent: 5,
                                  endIndent: 5,
                                  color: ThemeText.themColor.withOpacity(0.3),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Center(
                                    child: SizedBox(
                                      height: 50,
                                      width: 200,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            shadowColor:
                                                const Color(0x00e0e0e0),
                                            shape: StadiumBorder(
                                                side: BorderSide(
                                                    color: ThemeText.themColor
                                                        .withOpacity(0.3),
                                                    width: 2))),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute<void>(
                                              builder: (BuildContext context) =>
                                                  const UpdateInfoPage(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Bilgileri Güncelle',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: ThemeText.themColor
                                                  .withOpacity(0.75)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]))
                      .toList()),
            ),
          ),
          bottomNavigationBar: const BottomMenu(2),
        ));
  }
}
