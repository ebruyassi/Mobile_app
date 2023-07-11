// ignore_for_file: library_private_types_in_public_api, avoid_returning_null_for_void

import 'package:bitirme_prejem/models/style.dart';
import 'package:bitirme_prejem/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bitirme_prejem/AppAndBottom/appbar.dart';
import 'package:bitirme_prejem/AppAndBottom/bottom_menu.dart';
//import 'package:bitirme_prejem/services/cart_db.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with SingleTickerProviderStateMixin {
  Color themColor = const Color.fromARGB(255, 87, 47, 233);
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseService service = FirebaseService();

  List basketList = [];
  var totalValue = 0;
  //Kullanıcı bilgileri List'e yazılıyor.
  void fetchUserBasket() async {
    var res = await service.getUserBasket(auth.currentUser?.uid);
    if (res.isEmpty) {
      // ignore: avoid_print
      print("Veri yok");
    } else {
      setState(() {
        basketList = res;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserBasket();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: const AppBarMenu(),
            body: SingleChildScrollView(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.78,
                  child: getPage()),
            ),
            bottomNavigationBar: const BottomMenu(1)),
      ),
    );
  }

  double cartTotalPrice() {
    double total = 0;
    for (var item in basketList) {
      total += item.price;
    }
    return total;
  }

  getPage() {
    if (basketList.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: MediaQuery.of(context).size.height,
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 15, left: 15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 20),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "Toplam: ${cartTotalPrice().roundToDouble()} TL",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeText.themColor.withOpacity(0.75)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FloatingActionButton.extended(
                              shape: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          ThemeText.themColor.withOpacity(0.3),
                                      width: 1.5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              backgroundColor: Colors.white,
                              foregroundColor: ThemeText.themColor,
                              onPressed: () async {
                                double total = cartTotalPrice().roundToDouble();
                                service.addOrders(
                                    total,
                                    basketList.length,
                                    auth.currentUser!.uid.toString(),
                                    basketList);
                                await service.deleteBasket();
                                if (context.mounted) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const CartPage()));
                                }
                              },
                              label: const Text('Siparişi Tamamla'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    verticalDirection: VerticalDirection.down,
                    children: basketList
                        .map(
                          (data) => ListView(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              children: [
                                Row(
                                  children: [
                                    Card(
                                      elevation: 5.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15)),
                                          side: BorderSide(
                                              width: 2,
                                              color: ThemeText.themColor
                                                  .withOpacity(0.3))),
                                      child: Center(
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15)),
                                          child: Image.network(
                                            data.imgUrl,
                                            fit: BoxFit.contain,
                                            width: 85,
                                            height: 80,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: ListTile(
                                            isThreeLine: true,
                                            title: Text(data.productName),
                                            subtitle:
                                                Text('Tutar: ${data.price}'),
                                            trailing: IconButton(
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection('Basket')
                                                    .doc(data.id)
                                                    .delete();
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute<void>(
                                                    builder: (BuildContext
                                                            context) =>
                                                        const CartPage(),
                                                  ),
                                                );
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: ThemeText.themColor,
                                              ),
                                            )))
                                  ],
                                ),
                                Divider(
                                    thickness: 2,
                                    color:
                                        ThemeText.themColor.withOpacity(0.3)),
                              ]),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
            height: MediaQuery.of(context).size.height,
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
            child: Center(
                child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.zero,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5.0,
                      offset: const Offset(0, 2),
                    ),
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Sepetinizde ürün bulunmamaktadır.",
                  style: TextStyle(fontSize: 18, color: ThemeText.themColor),
                ),
              ),
            ))),
      );
    }
  }
}
