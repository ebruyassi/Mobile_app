import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bitirme_prejem/services/firebase_service.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
FirebaseService service = FirebaseService();
Future<List> fetchUserBasedRec() async {
  List productData;
  var selectedRecSystem = 'userBasedCF';
  Random randomValue = new Random();
  late Future<List> productsInfo;
  if (selectedRecSystem == "userBasedCF") {
    http.Response response = await http.get(Uri.parse(
        'http://192.168.1.51:2530/api/userBased?query=${auth.currentUser?.uid}'));
    productData = json.decode(response.body);
    debugPrint(productData.toString());
    productsInfo = service.getProductInfo(productData);
    debugPrint(productsInfo.toString());
  } else if (selectedRecSystem == "knn") {
    List productList;
    productList = await service.getUserOrders();
    var productName =
        productList[randomValue.nextInt(productList.length - 1)].productName;
    http.Response response = await http.get(Uri.parse(
        'http://192.168.1.51:2530/api/knnAlg?query=${productName.toString()}'));
    productData = json.decode(response.body);
    debugPrint(productData.toString());
    productsInfo = service.getProductInfo(productData);
    debugPrint(productsInfo.toString());
  } else if (selectedRecSystem == "svdAlg") {
    http.Response response = await http.get(Uri.parse(
        'http://192.168.1.51:2530/api/svdAlg?query=${auth.currentUser?.uid}'));
    productData = json.decode(response.body);
    debugPrint(productData.toString());
    productsInfo = service.getProductInfo(productData);
    debugPrint(productsInfo.toString());
  }
  return productsInfo;
}
