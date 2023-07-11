// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names
import 'package:bitirme_prejem/models/product_model.dart';
import 'package:bitirme_prejem/models/style.dart';
import 'package:bitirme_prejem/pages/product_info.dart';
import 'package:bitirme_prejem/services/http_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bitirme_prejem/AppAndBottom/bottom_menu.dart';
import 'package:bitirme_prejem/services/firebase_service.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  __ProductPageState createState() => __ProductPageState();
}

class __ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin, RestorationMixin {
  TabController? _tabController;
  FirebaseService service = FirebaseService();

  final RestorableInt tabIndex = RestorableInt(0);
  late String downloadUrl;
  @override
  String get restorationId => 'tab_scrollable_demo';

  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController!.index = tabIndex.value;
  }

  late List productsRec = [];
  void fetchProductsInfo() async {
    var res = await fetchUserBasedRec();
    if (res.isEmpty) {
      // ignore: avoid_print
      print("Veri yok");
    } else {
      setState(() {
        productsRec = res;
      });
    }
  }

  @override
  void initState() {
    fetchProductsInfo();
    _tabController = TabController(
      initialIndex: 0,
      length: 10,
      vsync: this,
    );
    _tabController!.addListener(() {
      setState(() {
        tabIndex.value = _tabController!.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      "Ana Sayfa",
      "Temel Gıda",
      "Süt ve Kahvaltılık",
      "Meyve ve Sebze",
      "Donmus Gıda",
      "İçecekler",
      "Et ve Tavuk",
      "Deterjan ve Temizleyici",
      "Deniz Ürünleri",
      "Bebek Ürünleri"
    ];
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        centerTitle: true,
        leading: const Text(''),
        backgroundColor: ThemeText.themColor,
        title: const Text(
          textAlign: TextAlign.center,
          "Tavsiye Sepeti",
          style: TextStyle(
            fontSize: 20, // Yazı büyüklüğü
            fontWeight: FontWeight.w500, // Yazı kalınlığı
            color: Colors.white, // Yazı rengi
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color.fromARGB(255, 255, 255, 255),
          isScrollable: true,
          tabs: [
            for (final tab in tabs) Tab(text: tab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Page1(),
          Page2(),
          Page2(),
          Page2(),
          Page2(),
          Page2(),
          Page2(),
          Page2(),
          Page2(),
          Page2(),
        ],
      ),
      bottomNavigationBar: const BottomMenu(0),
    );
  }

  getTittle(var tabName) {
    switch (tabName) {
      case 1:
        return "temelgida_sekerleme";
      case 2:
        return "süt_kahvaltılık";
      case 3:
        return "meyve_sebze";
      case 4:
        return "donmus_gida";
      case 5:
        return "icecekler";
      case 6:
        return "et_tavuk";
      case 7:
        return "deterjan_temiizleyici";
      case 8:
        return "deniz_urunleri";
      case 9:
        return "bebek";
    }
  }

  Page1() {
    if (productsRec.isNotEmpty) {
      return GridView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: productsRec.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(30, 20, 30, 10),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: ThemeText.themColor.withOpacity(0.5),
                      blurRadius: 5.0,
                      offset: const Offset(0, 2),
                    ),
                  ]),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      child: Image(
                        height: 100,
                        image: NetworkImage(
                          productsRec[index].img_url,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    color: ThemeText.themColor.withOpacity(0.3),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                ProductInfoPage(productsRec[index]),
                          ),
                        );
                      },
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(4, 4, 0, 0),
                        child: Text(
                          productsRec[index].name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black),
                          textAlign: TextAlign.start,
                        ),
                      )),
                  Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(8, 4, 0, 10),
                      child: ElevatedButton(
                        onPressed: () {
                          service.checkBasket(productsRec[index], 1);
                        },
                        style: ButtonStyle(
                          fixedSize:
                              MaterialStateProperty.all(const Size(150, 40)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              side: BorderSide(
                                  color: ThemeText.themColor.withOpacity(0.3),
                                  width: 3,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          elevation: MaterialStateProperty.all(5),
                          shadowColor: MaterialStateProperty.all(Colors.grey),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.add,
                                color: ThemeText.themColor.withOpacity(0.5),
                              ),
                            ),
                            Text(
                              '${productsRec[index].price.toString()} TL',
                              style: TextStyle(
                                  color: ThemeText.themColor.withOpacity(0.75),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
      );
    } else {
      return const Text('');
    }
  }

  Padding Page2() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Products')
            .where('category', isEqualTo: getTittle(tabIndex.value))
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return LayoutBuilder(builder: (context, constraints) {
              return GridView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = snapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 4),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: ThemeText.themColor.withOpacity(0.5),
                                blurRadius: 5.0,
                                offset: const Offset(0, 2),
                              ),
                            ]),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(0),
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                                child: Image.network(
                                  doc['img_url'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Divider(
                              thickness: 2,
                              color: ThemeText.themColor.withOpacity(0.3),
                            ),
                            TextButton(
                                onPressed: () {
                                  Product pInfo = Product(
                                    doc.data().toString().contains('info')
                                        ? doc.get('info')
                                        : '',
                                    doc.data().toString().contains('img_url')
                                        ? doc.get('img_url')
                                        : '',
                                    doc.data().toString().contains('price')
                                        ? double.parse(doc["price"]
                                            .replaceFirst(RegExp('.'), '')
                                            .replaceFirst(RegExp(','), '.'))
                                        : 0.0,
                                    doc.data().toString().contains('name')
                                        ? doc.get('name')
                                        : '',
                                    doc.data().toString().contains('contents')
                                        ? doc.get('contents')
                                        : '',
                                    doc
                                            .data()
                                            .toString()
                                            .contains('nutritional_value')
                                        ? doc.get('nutritional_value')
                                        : '',
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          ProductInfoPage(pInfo),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      4, 4, 0, 0),
                                  child: Text(
                                    doc['name'],
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.black),
                                    textAlign: TextAlign.start,
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8, 4, 0, 5),
                              child: ElevatedButton(
                                onPressed: () {
                                  Product pInfo = Product(
                                      doc['info'],
                                      doc['img_url'],
                                      double.parse(doc['price']
                                          .replaceFirst(RegExp('.'), '')
                                          .replaceFirst(RegExp(','), '.')),
                                      doc['name'],
                                      doc['contents'],
                                      doc['nutritional_value']);
                                  service.checkBasket(pInfo, 1);
                                },
                                style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all(
                                      const Size(120, 40)),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: ThemeText.themColor
                                              .withOpacity(0.4),
                                          width: 2,
                                          style: BorderStyle.solid),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  elevation: MaterialStateProperty.all(5),
                                  shadowColor:
                                      MaterialStateProperty.all(Colors.grey),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Icon(
                                        Icons.add,
                                        color: ThemeText.themColor
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                    Text(
                                      '${doc['price']} TL',
                                      style: TextStyle(
                                          color: ThemeText.themColor
                                              .withOpacity(0.8),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisSpacing: 4.0),
              );
            });
          } else {
            return const Text(" ");
          }
        },
      ),
    );
  }
}
