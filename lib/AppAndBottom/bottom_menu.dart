// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:bitirme_prejem/models/cart.dart';
import 'package:bitirme_prejem/models/style.dart';
import 'package:bitirme_prejem/services/firebase_service.dart';
import 'package:bitirme_prejem/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bitirme_prejem/pages/cart_page.dart';
import 'package:bitirme_prejem/pages/product_page.dart';
import 'package:bitirme_prejem/pages/profile_page.dart';
import 'package:badges/badges.dart' as badges;

class BottomMenu extends StatefulWidget {
  final selectIndex;

  const BottomMenu(this.selectIndex, {Key? key}) : super(key: key);

  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  final bool _showCartBadge = true;
  int? _cartBadgeAmount;
  FirebaseService service = FirebaseService();

  getCount() async {
    List<Cart> count = await service.getUserBasket(auth.currentUser?.uid);
    _cartBadgeAmount = count.length;
    return _cartBadgeAmount;
  }

  @override
  void initState() {
    super.initState();

    getCount();
    setState(() {
      _cartBadgeAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomNavigationBar(
            currentIndex: widget.selectIndex,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            selectedItemColor: ThemeText.themColor,
            unselectedItemColor: Colors.grey[500],
            showUnselectedLabels: true,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const ProductPage(),
                        ),
                      );
                    },
                    icon: const Icon(FontAwesomeIcons.house),
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  icon: IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => const CartPage(),
                          ),
                        );
                      }),
                  label: ""),
              BottomNavigationBarItem(
                  icon: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const ProfilePage(),
                        ),
                      );
                    },
                    icon: const Icon(FontAwesomeIcons.solidUser),
                  ),
                  label: ""),
            ],
          ),
        ));
  }
}
