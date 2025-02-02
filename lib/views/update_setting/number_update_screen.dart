import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Expoplace/composant/input_composant.dart';
import 'package:Expoplace/composant/show_message_composant.dart';
import 'package:Expoplace/controllers/accoun_controller.dart';
import 'package:Expoplace/service/datafirestore_service.dart';

class NumberUpdateScreen extends StatefulWidget {
  NumberUpdateScreen({Key? key}) : super(key: key);

  @override
  State<NumberUpdateScreen> createState() => _NumberUpdateScreenState();
}

class _NumberUpdateScreenState extends State<NumberUpdateScreen> {
  final number = TextEditingController();

  final account = Get.put(AccounController());
  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      padding: const EdgeInsets.all(10),
      child: Form(
        key: key,
        child: Column(
          children: <Widget>[
            Container(
              height: 5,
              width: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.black),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
                "En modifiant le numéro de votre boutique cela va impacter les commandes sur votre boutique ainsi que les discussions effectuées avec les autres clients"),
            const SizedBox(
              height: 10,
            ),
            InputComposant(
              hintText: account.accountdata.value!.number,
              nomText: 'Numéro Whatsapp',
              minLines: 1,
              controller: number,
              istexte: false,
            ),
            ElevatedButton(
                onPressed: () {
                  if (number.text.isNotEmpty) {
                    DatafirestoreService.data_firestore_account
                        .doc(account.accountdata.value!.accountuid)
                        .update({"number": number.text});
                    ShowMessageComposant.messagesucces(
                        context, " Numéro modifie avec succès.");
                    Navigator.pop(context);
                  }
                },
                child: const Text("Modifier"))
          ],
        ),
      ),
    );
  }
}
