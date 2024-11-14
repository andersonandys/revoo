import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revoo/composant/input_composant.dart';
import 'package:revoo/composant/show_message_composant.dart';
import 'package:revoo/controllers/accoun_controller.dart';
import 'package:revoo/service/datafirestore_service.dart';

class NameUpdateScreen extends StatefulWidget {
  NameUpdateScreen({Key? key}) : super(key: key);

  @override
  State<NameUpdateScreen> createState() => _NameUpdateScreenState();
}

class _NameUpdateScreenState extends State<NameUpdateScreen> {
  final nom = TextEditingController();

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
                "En Modifiant le nom de votre boutique cela va empacter le lien de votre boutique ainsi que la disponibilite du lien que vous avez partage avec vos client"),
            const SizedBox(
              height: 10,
            ),
            InputComposant(
              hintText: account.accountdata.value!.name,
              nomText: 'Nom boutique',
              minLines: 1,
              controller: nom,
            ),
            ElevatedButton(
                onPressed: () {
                  if (nom.text.isNotEmpty) {
                    DatafirestoreService.data_firestore_account
                        .doc(account.accountdata.value!.accountuid)
                        .update({"name": nom.text});
                    ShowMessageComposant.messagesucces(
                        context, "Section ajoute avec succes");
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
