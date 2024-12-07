import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Expoplace/composant/menu_composant.dart';
import 'package:Expoplace/views/chart/chart_requette_screen.dart';
import 'package:Expoplace/views/chart/chart_vente_screen.dart';
import 'package:Expoplace/views/chart/chart_visit_screen.dart';
import 'package:Expoplace/views/chart/global_chart_screen.dart';
import 'package:Expoplace/views/chart/stat_product_screen.dart';

import '../controllers/accoun_controller.dart';

class StatScreen extends StatefulWidget {
  const StatScreen({Key? key}) : super(key: key);

  @override
  _StatScreenState createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
  final productController = Get.put(AccounController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Statistiques"),
          centerTitle: true,
          leading: const MenuWidget()),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StatProductScreen(),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Statistique des requêtes",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 320,
                child: ChartRequetteScreen(),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Statistique des ventes",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              (productController.accountdata.value!.offre == "premium" ||
                      productController.accountdata.value!.offre ==
                          "entreprise")
                  ? Container(
                      height: 320,
                      child: ChartVenteScreen(),
                    )
                  : const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        " Accès limité à cette statistique Votre plan actuel ne vous permet pas d'accéder à cette fonctionnalité. \n Pour en bénéficier, nous vous invitons à passer à un plan incluant les statistiques avancées.",
                        style: TextStyle(),
                        textAlign: TextAlign.justify,
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Statistique des visites",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              (productController.accountdata.value!.offre == "premium" ||
                      productController.accountdata.value!.offre ==
                          "entreprise")
                  ? Container(
                      height: 320,
                      child: ChartVisitScreen(),
                    )
                  : const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        " Accès limité à cette statistique Votre plan actuel ne vous permet pas d'accéder à cette fonctionnalité. \n Pour en bénéficier, nous vous invitons à passer à un plan incluant les statistiques avancées.",
                        style: TextStyle(),
                        textAlign: TextAlign.justify,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
