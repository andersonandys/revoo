import 'package:Expoplace/main.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Expoplace/models/account_model.dart';
import 'package:Expoplace/models/accountstat_model.dart';
import 'package:Expoplace/models/product_model.dart';
import 'package:Expoplace/service/datafirestore_service.dart';
import 'package:Expoplace/views/update_setting/product_update_screen.dart';

class AccounController extends GetxController {
  var accountuid = "".obs;
  var accountdata = Rxn<AccountModel>();
  final products = <ProductModel>[].obs;
  var monthlyStats = Rxn<AccountstatModel>();
  var updateproduct = Rxn<ProductModel>();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    if (globalUid != null) {
      getdataAccount();
      getproduct();
      fetchCurrentMonthStats();
    }
  }

// function pour recuprer les data de la boutique
  getdataAccount() {
    DatafirestoreService.data_firestore_account
        .doc(globalUid)
        .snapshots()
        .listen((event) {
      if (event.data() != null) {
        accountdata.value =
            AccountModel.fromJson(event.data() as Map<String, dynamic>);
      } else {}
    });
  }

// function pour recuperer les produits
  getproduct() {
    DatafirestoreService.data_firestore_product
        .where("accountuid", isEqualTo: globalUid)
        .snapshots()
        .listen((event) {
      products.value =
          event.docs.map((e) => ProductModel.fromJson(e.data())).toList();
    });
  }

  // Fonction pour récupérer les statistiques mensuelles d'un utilisateur
  Future<void> fetchCurrentMonthStats() async {
    final DateTime now = DateTime.now();
    final String year = now.year.toString();
    final String month =
        now.month.toString().padLeft(2, '0'); // Format '01', '02', etc.

    try {
      DatafirestoreService.data_firestore_account
          .doc(
              globalUid) // Remplace 'userId' par l'ID de l'utilisateur connecté si nécessaire
          .collection('stats')
          .doc(month)
          .snapshots()
          .listen((event) {
        if (event.data() != null) {
          monthlyStats.value =
              AccountstatModel.fromJson(event.data() as Map<String, dynamic>);
        } else {}
      });
    } catch (e) {
      monthlyStats.value = null;
    }
  }

  // function pour recuprer le produit a modifier
  productsupdate(String idproduct, context) {
    print(idproduct);
    DatafirestoreService.data_firestore_product
        .doc(idproduct)
        .snapshots()
        .listen((event) {
      if (event.data() != null) {
        updateproduct.value =
            ProductModel.fromJson(event.data() as Map<String, dynamic>);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProductUpdateScreen()));
      } else {}
    });
  }
}
