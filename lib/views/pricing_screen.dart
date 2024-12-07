import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:Expoplace/views/paiement_screen.dart';

class PricingScreen extends StatefulWidget {
  const PricingScreen({Key? key}) : super(key: key);

  @override
  _PricingScreenState createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen> {
  // Liste de données pour le pricing
  final List<Map<String, dynamic>> pricingPlans = [
    {
      "name": "Basic",
      "description": "Idéal pour les petits commerces.",
      "price": "2000",
      "features": [
        "Gestion des produits : 10 unités",
        "Statistiques de base",
        null,
        null,
        null,
        null,
        "Support 24/7",
      ],
    },
    {
      "name": "Premium",
      "description": "Pour les commerces en croissance.",
      "price": "5000",
      "features": [
        "Gestion des produits : 100 unités",
        "Statistiques avancées",
        "Présence dans le mapping",
        null,
        null,
        null,
        "Support 24/7",
      ],
    },
    {
      "name": "Entreprise",
      "description": "Pour les grandes entreprises.",
      "price": "10000",
      "features": [
        "Gestion  des produits illimités",
        "Statistiques avancées",
        "Présence dans le mapping",
        "Choix de paiement dédié",
        "Notification par sms",
        "Personnalisation de théme",
        "Support dédié",
      ],
    },
  ];

  final ValueNotifier<String> _selectedSegment = ValueNotifier('all');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Choisissez le plan qui correspond à vos besoins 🚀",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0D3B66),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                "Nous vous offrons des plans adaptés pour chaque type d'utilisateur. Que vous soyez une petite boutique, un professionnel, ou une grande entreprise, vous trouverez un plan qui vous convient.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 30),
              AdvancedSegment(
                controller: _selectedSegment,
                segments: const {
                  'basic': 'Basic',
                  'premium': 'Premium',
                  'entreprise': 'Entreprise',
                },
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder<String>(
                valueListenable: _selectedSegment,
                builder: (context, value, child) {
                  // Afficher les informations en fonction du segment sélectionné
                  List<Map<String, dynamic>> filteredPlans;
                  if (value == 'basic') {
                    filteredPlans = [pricingPlans[0]];
                  } else if (value == 'premium') {
                    filteredPlans = [pricingPlans[1]];
                  } else {
                    filteredPlans = [pricingPlans[2]];
                  }

                  return Column(
                    children: filteredPlans.map((plan) {
                      return FeatureCard(
                        name: plan["name"],
                        description: plan["description"],
                        price: plan["price"],
                        features: plan["features"],
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String name;
  final String description;
  final String price;
  final List<String?> features;

  const FeatureCard({
    Key? key,
    required this.name,
    required this.description,
    required this.price,
    required this.features,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xfff4f7fa),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(price,
                  style: const TextStyle(
                      fontSize: 50, fontWeight: FontWeight.bold)),
              const Text("/mois", style: TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 30),
          ...features.map((feature) {
            if (feature != null) {
              return ListTile(
                leading: const Icon(
                  Icons.check_circle_outline_outlined,
                  color: Colors.greenAccent,
                ),
                title: Text(feature),
              );
            } else {
              return const ListTile(
                leading: Icon(
                  Icons.cancel_outlined,
                  color: Colors.grey,
                ),
                title: Text("Non inclus"),
              );
            }
          }).toList(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaiementScreen(
                            montant: int.parse(price),
                          )));
            },
            child: const Text(
              "Commencer",
              style: TextStyle(fontSize: 20, color: Color(0xff0D3B66)),
            ),
          )
        ],
      ),
    );
  }
}
