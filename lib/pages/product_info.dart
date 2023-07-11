// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, library_private_types_in_public_api, no_logic_in_create_state

import 'package:bitirme_prejem/models/product_model.dart';
import 'package:bitirme_prejem/models/style.dart';
import 'package:bitirme_prejem/pages/cart_page.dart';
import 'package:bitirme_prejem/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductInfoPage extends StatefulWidget {
  var doc;
  ProductInfoPage(this.doc, {Key? key}) : super(key: key);

  @override
  __ProductInfoPageState createState() => __ProductInfoPageState(doc);
}

class __ProductInfoPageState extends State<ProductInfoPage> {
  Product doc;

  bool info = false;
  bool contents = false;
  bool nutritionalValue = false;
  FirebaseService service = FirebaseService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  int _n = 1;
  __ProductInfoPageState(this.doc);
  void add() {
    setState(() {
      _n++;
    });
  }

  void minus() {
    setState(() {
      if (_n != 0) _n--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: ThemeText.themColor,
          title: Text(doc.name,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const CartPage(),
                    ),
                  );
                },
                icon: const Icon(FontAwesomeIcons.basketShopping))
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            color: ThemeText.themColor.withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: 5),
                      ],
                    ),
                    child: Image.network(
                      doc.img_url,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      heroTag: "btn2",
                      onPressed: minus,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.remove,
                        color: ThemeText.themColor.withOpacity(0.7),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('$_n',
                          style: const TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w500)),
                    ),
                    FloatingActionButton(
                      heroTag: "btn1",
                      onPressed: add,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.add,
                        color: ThemeText.themColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 15,
                  thickness: 2,
                  indent: 15,
                  endIndent: 15,
                  color: ThemeText.themColor.withOpacity(0.3),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          if (info) {
                            setState(() {
                              info = false;
                            });
                          } else {
                            setState(() {
                              info = true;
                            });
                          }
                        },
                        icon: Icon(
                          FontAwesomeIcons.circlePlus,
                          color: ThemeText.themColor.withOpacity(0.77),
                        )),
                    const Text(
                      'Ürün Açıklaması',
                    )
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6),
                  child: Visibility(
                      visible: info,
                      child: Text(
                        doc.info,
                      )),
                ),
                Divider(
                  height: 15,
                  thickness: 2,
                  indent: 15,
                  endIndent: 15,
                  color: ThemeText.themColor.withOpacity(0.3),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          if (contents) {
                            setState(() {
                              contents = false;
                            });
                          } else {
                            setState(() {
                              contents = true;
                            });
                          }
                        },
                        icon: Icon(FontAwesomeIcons.circlePlus,
                            color: ThemeText.themColor.withOpacity(0.77))),
                    const Text(
                      'İçindekiler',
                    )
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6),
                  child: Visibility(
                      visible: contents,
                      child: doc.contents == ''
                          ? Text(doc.contents)
                          : const Text(
                              'Ürünün İçerik Bilgisi Bulunmamaktadır.')),
                ),
                Divider(
                  height: 15,
                  thickness: 2,
                  indent: 15,
                  endIndent: 15,
                  color: ThemeText.themColor.withOpacity(0.3),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          if (nutritionalValue) {
                            setState(() {
                              nutritionalValue = false;
                            });
                          } else {
                            setState(() {
                              nutritionalValue = true;
                            });
                          }
                        },
                        icon: Icon(
                          FontAwesomeIcons.circlePlus,
                          color: ThemeText.themColor.withOpacity(0.77),
                        )),
                    const Text(
                      'Besin Değerleri',
                    )
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6),
                  child: Visibility(
                      visible: nutritionalValue,
                      child: doc.nutritional_value == ''
                          ? Text(doc.nutritional_value)
                          : const Text(
                              'Ürünün Besin Değerleri Bilgisi Bulunmamaktadır.')),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black38, spreadRadius: 0, blurRadius: 10),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton.extended(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: ThemeText.themColor.withOpacity(0.6),
                            width: 3,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: ThemeText.themColor.withOpacity(0.8),
                      onPressed: () {
                        Product pInfo = Product(
                            doc.info,
                            doc.img_url,
                            double.parse(doc.price
                                .toString()
                                .replaceFirst(RegExp(','), '.')),
                            doc.name,
                            doc.contents,
                            doc.nutritional_value);
                        service.checkBasket(pInfo, _n);
                      },
                      label: const Text('Sepete Ekle'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(doc.price.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 28)),
                        const Text(" TL",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15))
                      ],
                    )
                  ],
                ),
              ),
            )));
  }
}
