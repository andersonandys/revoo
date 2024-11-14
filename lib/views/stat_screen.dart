import 'package:flutter/material.dart';
import 'package:revoo/composant/menu_composant.dart';
import 'package:revoo/views/chart/global_chart_screen.dart';

class StatScreen extends StatefulWidget {
  const StatScreen({Key? key}) : super(key: key);

  @override
  _StatScreenState createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
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
              const Text(
                "Statistique requette",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 320,
                child: GlobalChartScreen(),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Statistique vente",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 320,
                child: GlobalChartScreen(),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Statistique visite",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 320,
                child: GlobalChartScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
