import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revoo/controllers/accoun_controller.dart';
import 'package:revoo/service/datafirestore_service.dart';
import 'package:revoo/views/creat_account/account_informartion_screen.dart';
import 'package:revoo/views/menu/home_menu.dart';

class LoadpageScreen extends StatefulWidget {
  const LoadpageScreen({Key? key}) : super(key: key);

  @override
  _LoadpageScreenState createState() => _LoadpageScreenState();
}

class _LoadpageScreenState extends State<LoadpageScreen> {
  final account = Get.put(AccounController());
  @override
  void initState() {
    super.initState();

    account.getdataAccount();
    account.getproduct();
    account.fetchCurrentMonthStats();
    Timer(const Duration(seconds: 5), () {
      gomenu();
    });
  }

  gomenu() async {
    final userDoc = DatafirestoreService.data_firestore_account
        .doc(FirebaseAuth.instance.currentUser!.uid);

    // Récupère le document de l'utilisateur pour vérifier s'il existe
    final docSnapshot = await userDoc.get();
    if (docSnapshot.exists) {
      if (account.accountdata.value!.name != "") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const HomeMenu(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                const AccountInformartionScreen(),
          ),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const AccountInformartionScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xffFFCF0D),
        ),
      ),
    );
  }
}
