// ignore_for_file: library_private_types_in_public_api, avoid_returning_null_for_void

import 'dart:async';
import 'dart:math';

import 'package:bitirme_prejem/models/order_model.dart';
import 'package:bitirme_prejem/models/style.dart';
import 'package:bitirme_prejem/services/firebase_service.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bitirme_prejem/AppAndBottom/appbar.dart';
import 'package:bitirme_prejem/AppAndBottom/bottom_menu.dart';
//import 'package:bitirme_prejem/services/cart_db.dart';
import 'package:grouped_list/grouped_list.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin {
  Color themColor = const Color.fromARGB(255, 87, 47, 233);
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseService service = FirebaseService();
  late List orderList = [];
  var totalValue = 0;
  List images = [];
  late PageController _pageController =
      PageController(viewportFraction: 0.8, initialPage: 0);
  int activePage = 1;
  //Kullanıcı bilgileri List'e yazılıyor.
  void getUserOrders() async {
    var res = await service.getUserOrders();
    if (res.isEmpty) {
      // ignore: avoid_print
      print("Veri yok");
    } else {
      setState(() {
        orderList = res;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserOrders();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
            backgroundColor: const Color.fromRGBO(243, 235, 235, 1),
            appBar: const AppBarMenu(),
            body: FutureBuilder(
              future: service.getUserOrders(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return const Center(child: Text("Yükleniyor..."));
                } else {
                  return GroupedListView<dynamic, String>(
                    elements: snapshot.data,
                    groupBy: (element) => element.orderDate.toString(),
                    groupSeparatorBuilder: (String element) => Padding(
                      padding: const EdgeInsets.all(5.0),
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
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        child: Center(
                            child: Text(
                          'Sipariş Tarihi: ${element.split(' ')[0]}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    itemBuilder: (context, dynamic element) => Card(
                      // This ensures that the Card's children (including the ink splash) are clipped correctly.
                      clipBehavior: Clip.antiAlias,
                      surfaceTintColor: ThemeText.themColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        children: [
                          FutureBuilder<String>(
                              future: getImages(element.productName),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Image.network(
                                      snapshot.data.toString());
                                }
                                return const CircularProgressIndicator();
                              }),
                          Divider(
                            thickness: 2,
                            color: ThemeText.themColor.withOpacity(0.3),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 5),
                            child: Row(
                              children: [
                                Text('Ürün Adı: ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                Text(element.productName,
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                            child: Row(
                              children: [
                                Text('Adet: ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                Text(element.count.toString(),
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 5),
                            child: Row(
                              children: [
                                Text('Tutar: ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                FutureBuilder<String>(
                                    future: getPrice(
                                        element.productName, element.count),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(snapshot.data.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall);
                                      }
                                      return const CircularProgressIndicator();
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ), // optional
                    useStickyGroupSeparators: false, // optional
                    floatingHeader: true, // optional
                    order: GroupedListOrder.ASC, // optional
                  );
                }
              },
            ),
            bottomNavigationBar: const BottomMenu(2)),
      ),
    );
  }

  Future<String> getImages(var order) async {
    var x = await service.getProductImage(order);
    return x;
  }

  Future<String> getPrice(var order, var count) async {
    var x = await service.getProductPrice(order);
    var price = double.parse(x) * count;
    return price.toString();
  }
}
