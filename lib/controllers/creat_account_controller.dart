import 'package:Expoplace/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Expoplace/controllers/accoun_controller.dart';
import 'package:Expoplace/models/account_model.dart';
import 'package:Expoplace/service/datafirestore_service.dart';
import 'package:Expoplace/views/loadpage_screen.dart';
import 'package:Expoplace/views/menu/home_menu.dart';

class CreatAccountController extends GetxController {
  var step_account = 0.obs;

  // Controllers pour les champs de la première étape
  TextEditingController nomController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController employeController = TextEditingController();
  // Controller pour les champs de la seconde etapes
  TextEditingController numero_controller = TextEditingController();
  TextEditingController localisation_controller = TextEditingController();
  TextEditingController lienstotre_controller = TextEditingController();
  var avatar = "".obs;
  // declaration dun key global pour l utiliser ailleurs
  var globalkey = GlobalKey<FormState>().obs;
  // recuperation de la localisation du compte
  var position_localisation = "".obs;

  @override
  void onClose() {
    nomController.dispose();
    descriptionController.dispose();
    employeController.dispose();
    numero_controller.dispose();
    localisation_controller.dispose();
    lienstotre_controller.dispose();
    super.onClose();
  }

  addacount(context) {
    DatafirestoreService.data_firestore_account.doc(globalUid).set(
          AccountModel(
                  name: nomController.text,
                  description: descriptionController.text,
                  avatar: avatar.value,
                  localisation: localisation_controller.text,
                  lienstore:
                      nomController.text.replaceAll(" ", "_").toLowerCase(),
                  position: position_localisation.value,
                  nbremployer: int.parse(employeController.text),
                  number: numero_controller.text,
                  accountuid: globalUid!,
                  offre: '',
                  nbreproduit: 0,
                  nbrereque: 0,
                  affiche: "",
                  expire: "",
                  nbrevente: 0,
                  nbrevisite: 0,
                  mdp: '')
              .toJson(),
        );
    saveMonthlyStatisticsWithMockData();

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => LoadpageScreen(),
      ),
    );
  }

  void saveMonthlyStatisticsWithMockData() async {
    final DateTime now = DateTime.now();
    final String month =
        now.month.toString().padLeft(2, '0'); // Format '01', '02', etc.

    FirebaseFirestore.instance
        .collection('account')
        .doc(globalUid)
        .collection("stats")
        .doc(month)
        .set({
      'visit': 0,
      'requette': 0,
      'produit': 0,
      'vente': 0,
    });
  }
}
