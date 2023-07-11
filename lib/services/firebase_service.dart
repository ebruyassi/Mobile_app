// ignore_for_file: avoid_print

import 'package:bitirme_prejem/models/cart.dart';
import 'package:bitirme_prejem/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bitirme_prejem/models/user.dart';
import 'package:flutter/material.dart';
import 'package:bitirme_prejem/models/order_model.dart';
import 'package:intl/intl.dart';

class FirebaseService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<List> getUserOrders() async {
    late List list = <Orders>[];
    await FirebaseFirestore.instance
        .collection('Orders')
        .where('uId', isEqualTo: auth.currentUser?.uid)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        var x = (doc['orderDate'] as Timestamp).toDate();
        list.add(Orders(doc["count"], doc["price"], doc["products"], doc["uId"],
            doc["orderId"], x));
      }
    });
    return list;
  }

  checkBasket(Product product, int count) async {
    List<Cart> list = <Cart>[];
    var id;
    await FirebaseFirestore.instance
        .collection("Basket")
        .where('product', isEqualTo: product.name)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        list.add(Cart(doc["count"], doc["price"], doc["product"], doc["uId"],
            doc['img_url'], doc["id"]));
        id = doc.id;
      }
      if (list.isNotEmpty) {
        var countt = list[0].count + count;
        String price = product.price.toString().replaceFirst(RegExp(','), '.');
        double total = double.parse(price) * countt;
        updateBasketValue(countt, id, total);
      } else {
        addBasket(product.price * count, count, auth.currentUser?.uid,
            product.name, product.img_url);
      }
    });
  }

  updateBasketValue(var count, var docId, double total) {
    var ref = FirebaseFirestore.instance.collection('Basket').doc(docId);

    ref
        .update({'count': count})
        .then((value) => print("count Updated"))
        .catchError((error) => print("Failed to update count: $error"));
    ref
        .update({'price': total})
        .then((value) => print("total Updated"))
        .catchError((error) => print("Failed to update total: $error"));
  }

  Future<List> getProductInfo(var productData) async {
    late List<Product> list = <Product>[];
    for (var i = 0; i < productData.length; i++) {
      debugPrint(productData[i].toString());
      debugPrint(productData.length.toString());
      // ignore: prefer_typing_uninitialized_variables
      var pInfo;
      await FirebaseFirestore.instance
          .collection("Products")
          .where('name', isEqualTo: productData[i].toString())
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          debugPrint(doc.toString());
          pInfo = Product(
            doc.data().toString().contains('info') ? doc.get('info') : '',
            doc.data().toString().contains('img_url') ? doc.get('img_url') : '',
            doc.data().toString().contains('price')
                ? double.parse(doc["price"].replaceFirst(RegExp(','), '.'))
                : 0.0,
            doc.data().toString().contains('name') ? doc.get('name') : '',
            doc.data().toString().contains('contents')
                ? doc.get('contents')
                : '',
            doc.data().toString().contains('nutritional_value')
                ? doc.get('nutritional_value')
                : '',
          );
        }
      });
      list.add(pInfo);
    }
    return list;
  }

  getUserBasket(var uId) async {
    late List<Cart> list = <Cart>[];
    var uId = auth.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection('Basket')
        .where('uId', isEqualTo: uId)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        list.add(Cart(doc["count"], doc["price"], doc["product"], uId!,
            doc['img_url'], doc["id"]));
      }
    });
    return list;
  }

  deleteBasket() async {
    List<Cart> basket = await getUserBasket(auth.currentUser?.uid);
    for (int i = 0; i < basket.length; i++) {
      await FirebaseFirestore.instance
          .collection('Basket')
          .doc(basket[i].id)
          .delete();
    }
  }

  addBasket(var price, var count, var uId, var product, var url) async {
    var id = uId + DateTime.now().toString();
    FirebaseFirestore.instance.collection('Basket').doc(id).set({
      "uId": uId,
      "price": price,
      "count": count,
      "product": product,
      "img_url": url,
      "id": id
    });
  }

  addOrders(double price, int count, String uId, List product) async {
    var id = uId + DateTime.now().toString();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);

    for (int i = 0; i < product.length; i++) {
      print(product[i].productName);
      FirebaseFirestore.instance
          .collection('Orders')
          .doc(uId + DateTime.now().toString())
          .set({
        "uId": uId,
        "price": price,
        "count": count,
        "products": product[i].productName,
        "orderId": id,
        "orderDate": now
      });
    }
  }

  Future<List> getUserInfo(var userID) async {
    late List<Users> list = <Users>[];
    await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: auth.currentUser?.email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        list.add(Users(doc["tel_no"], doc["fName"], doc["lName"], doc["email"],
            doc["allergieType"], doc["address"]));
      }
    });
    return list;
  }

  updateInformation(userId, fNameController, lNameController, eMailController,
      phoneNoController, allergieTypeController) {
    var ref = FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser?.uid);

    ref
        .update({'fName': fNameController})
        .then((value) => print("firstName Updated"))
        .catchError((error) => print("Failed to update firstName: $error"));
    ref
        .update({'lName': lNameController})
        .then((value) => print("lastName Updated"))
        .catchError((error) => print("Failed to update lastName: $error"));
    ref
        .update({'email': eMailController})
        .then((value) => print("email Updated"))
        .catchError((error) => print("Failed to update email: $error"));
    ref
        .update({'tel_no': phoneNoController})
        .then((value) => print("phoneNumber Updated"))
        .catchError((error) => print("Failed to update phoneNumber: $error"));
    ref
        .update({'allergieType': allergieTypeController})
        .then((value) => print("allergieType Updated"))
        .catchError((error) => print("Failed to update allergieType: $error"));
  }

  Future<String> getProductImage(var name) async {
    late Product list;
    await FirebaseFirestore.instance
        .collection('Products')
        .where('name', isEqualTo: name)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        list = Product(
          doc.data().toString().contains('info') ? doc.get('info') : '',
          doc.data().toString().contains('img_url') ? doc.get('img_url') : '',
          doc.data().toString().contains('price')
              ? double.parse(doc["price"].replaceFirst(RegExp(','), '.'))
              : 0.0,
          doc.data().toString().contains('name') ? doc.get('name') : '',
          doc.data().toString().contains('contents') ? doc.get('contents') : '',
          doc.data().toString().contains('nutritional_value')
              ? doc.get('nutritional_value')
              : '',
        );
      }
    });
    return list.img_url;
  }

  Future<String> getProductPrice(var name) async {
    late Product list;
    await FirebaseFirestore.instance
        .collection('Products')
        .where('name', isEqualTo: name)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        list = Product(
          doc.data().toString().contains('info') ? doc.get('info') : '',
          doc.data().toString().contains('img_url') ? doc.get('img_url') : '',
          doc.data().toString().contains('price')
              ? double.parse(doc["price"].replaceFirst(RegExp(','), '.'))
              : 0.0,
          doc.data().toString().contains('name') ? doc.get('name') : '',
          doc.data().toString().contains('contents') ? doc.get('contents') : '',
          doc.data().toString().contains('nutritional_value')
              ? doc.get('nutritional_value')
              : '',
        );
      }
    });
    return list.price.toString();
  }
}
