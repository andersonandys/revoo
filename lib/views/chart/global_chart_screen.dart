import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revoo/controllers/accoun_controller.dart';
import 'package:revoo/models/accountstat_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GlobalChartScreen extends StatelessWidget {
  final statsController = Get.put(AccounController());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 300,
        width: double.infinity,
        child: Obx(() {
          // Crée une liste de données pour le graphique
          List<_SalesData> data = [
            _SalesData('Visites',
                statsController.monthlyStats.value!.visit.toDouble()),
            _SalesData('Requêtes',
                statsController.monthlyStats.value!.requette.toDouble()),
            _SalesData('Produit',
                statsController.monthlyStats.value!.produit.toDouble()),
            _SalesData(
                'Ventes', statsController.monthlyStats.value!.vente.toDouble()),
          ];

          // Affiche le graphique avec les données dynamiques
          return SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            legend: Legend(isVisible: true),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries<_SalesData, String>>[
              LineSeries<_SalesData, String>(
                dataSource: data,
                xValueMapper: (_SalesData sales, _) => sales.label,
                yValueMapper: (_SalesData sales, _) => sales.value,
                name: 'Statistiques',
                dataLabelSettings: DataLabelSettings(isVisible: true),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// Modèle pour les données de graphique
class _SalesData {
  _SalesData(this.label, this.value);

  final String label;
  final double value;
}
