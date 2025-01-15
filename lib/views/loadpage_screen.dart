import 'dart:async';

import 'package:Expoplace/controllers/creat_account_controller.dart';
import 'package:Expoplace/main.dart';
import 'package:Expoplace/views/creat_accountShop/account_informartion_screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Expoplace/controllers/accoun_controller.dart';
import 'package:Expoplace/service/datafirestore_service.dart';
import 'package:Expoplace/views/menu/home_menu.dart';

class LoadpageScreen extends StatefulWidget {
  const LoadpageScreen({Key? key}) : super(key: key);

  @override
  _LoadpageScreenState createState() => _LoadpageScreenState();
}

class _LoadpageScreenState extends State<LoadpageScreen> {
  final account = Get.put(AccounController());
  final creatController = Get.put(CreatAccountController());
  @override
  initState() {
    super.initState();
    account.getdataAccount();
    account.getproduct();
    account.fetchCurrentMonthStats();
    Timer(const Duration(seconds: 3), () {
      gomenu();
    });
  }

  gomenu() async {
    final userDoc = DatafirestoreService.data_firestore_account.doc(globalUid);

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
        creatController.numero_controller.text =
            account.accountdata.value!.number;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                const AccountInformartionScreen(),
          ),
        );
      }
    } else {
      creatController.numero_controller.text =
          account.accountdata.value!.number;
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
