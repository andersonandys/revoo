import 'dart:math';

import 'package:cinetpay/cinetpay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Expoplace/service/datafirestore_service.dart';

class PaiementScreen extends StatefulWidget {
  int montant;
  PaiementScreen({Key? key, required this.montant}) : super(key: key);

  @override
  _PaiementScreenState createState() => _PaiementScreenState();
}

class _PaiementScreenState extends State<PaiementScreen> {
  TextEditingController amountController = TextEditingController();
  Map<String, dynamic>? response;
  Color? color;
  IconData? icon;
  String message = "";
  bool show = false;
  String title = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Paiement"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              show
                  ? Text(
                      title,
                      style: const TextStyle(
                          fontSize: 20, color: Color(0xff0D3B66)),
                      textAlign: TextAlign.center,
                    )
                  : Container(),
              const SizedBox(height: 30),
              show
                  ? Center(
                      child: Icon(icon, color: color, size: 150),
                    )
                  : Container(),
              const SizedBox(height: 30),
              show ? Text(message) : Container(),
              show ? const SizedBox(height: 50.0) : Container(),
              if (!show) ...[
                const Text(
                  "Confirmez votre paiement pour activer votre compte !",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0D3B66),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Icon(Icons.lock, color: Colors.green, size: 20),
                const SizedBox(width: 5),
                const Text(
                  "Sécurisé et rapide : Toutes vos transactions sont protégées.",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                const Icon(Icons.swap_horiz, color: Colors.blue, size: 20),
                const SizedBox(width: 5),
                const Text(
                  "Flexibilité : Passez à un autre plan ou annulez à tout moment.",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                const Icon(Icons.transit_enterexit,
                    color: Colors.orange, size: 20),
                const SizedBox(width: 5),
                const Text(
                  "Transparence : Aucun frais caché, vous ne payez que ce que vous utilisez.",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Important :",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Après validation, votre compte sera automatiquement activé et vous pourrez immédiatement profiter des avantages de votre plan sélectionné. Si vous rencontrez un problème, contactez notre support client via notre centre d'aide.",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
              ],
              const Spacer(),
              if (!show)
                ElevatedButton(
                  child: const Text("Payer maintenant"),
                  onPressed: () async {
                    print(widget.montant);
                    String amount = widget.montant.toString();
                    if (amount.isEmpty) {
                      // Mettre une alerte
                      return;
                    }
                    double _amount;
                    try {
                      _amount = double.parse(amount);

                      if (_amount < 100) {
                        // Mettre une alerte
                        return;
                      }

                      if (_amount > 1500000) {
                        // Mettre une alerte
                        return;
                      }
                    } catch (exception) {
                      return;
                    }

                    amountController.clear();

                    final String transactionId = Random()
                        .nextInt(100000000)
                        .toString(); // Mettre en place un endpoint à contacter côté serveur pour générer des ID unique dans votre BD

                    await Get.to(CinetPayCheckout(
                      title: 'Paiement',
                      titleStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      titleBackgroundColor: Colors.green,
                      configData: <String, dynamic>{
                        'apikey': '12845785286114ff4e94f6e9.88416188',
                        'site_id': int.parse("488264"),
                      },
                      paymentData: <String, dynamic>{
                        'transaction_id': transactionId,
                        'amount': _amount,
                        'currency': 'XOF',
                        'channels': 'ALL',
                        'description': 'Payment test',
                      },
                      waitResponse: (data) {
                        if (mounted) {
                          setState(() {
                            response = data;
                            print(response);
                            icon = data['status'] == 'ACCEPTED'
                                ? Icons.check_circle
                                : Icons.mood_bad_rounded;
                            color = data['status'] == 'ACCEPTED'
                                ? Colors.green
                                : Colors.redAccent;
                            show = true;

                            if (data['status'] == 'ACCEPTED') {
                              // Calcul du mois et de l'année d'expiration
                              DateTime now = DateTime.now();
                              DateTime nextMonth = (now.month == 12)
                                  ? DateTime(now.year + 1, 1,
                                      now.day) // Passer à janvier de l'année suivante si décembre
                                  : DateTime(now.year, now.month + 1, now.day);

                              String formattedExpire =
                                  "${nextMonth.day}-${nextMonth.month}-${nextMonth.year}";

                              switch (widget.montant) {
                                case 2000:
                                  DatafirestoreService.data_firestore_account
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .update({
                                    "offre": "basic",
                                    "expire": formattedExpire,
                                  });
                                  break;
                                case 5000:
                                  DatafirestoreService.data_firestore_account
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .update({
                                    "offre": "premium",
                                    "expire": formattedExpire,
                                  });
                                  break;
                                case 10000:
                                  DatafirestoreService.data_firestore_account
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .update({
                                    "offre": "entreprise",
                                    "expire": formattedExpire,
                                  });
                                  break;
                                default:
                              }
                            }

                            data['status'] == 'ACCEPTED'
                                ? message =
                                    "Profitez dès maintenant des avantages de votre compte premium : accès à toutes les fonctionnalités, support prioritaire et bien plus !"
                                : message =
                                    "Si le problème persiste, veuillez vérifier votre méthode de paiement ou contacter notre support.";
                            data['status'] == 'ACCEPTED'
                                ? title =
                                    "Votre compte a été mis à jour avec succès ! 🎉"
                                : title =
                                    "Le paiement a échoué. Veuillez réessayer.";

                            Get.back();
                          });
                        }
                      },
                      onError: (data) {
                        if (mounted) {
                          setState(() {
                            response = data;
                            message = response!['description'];
                            print(response);
                            icon = Icons.warning_rounded;
                            color = Colors.yellowAccent;
                            show = true;
                            Get.back();
                          });
                        }
                      },
                    ));
                  },
                )
            ],
          ),
        ));
  }
}
