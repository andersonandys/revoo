import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Expoplace/composant/input_composant.dart';
import 'package:Expoplace/composant/show_message_composant.dart';
import 'package:Expoplace/controllers/accoun_controller.dart';
import 'package:Expoplace/service/datafirestore_service.dart';

class DescriptionUpdateScreen extends StatefulWidget {
  DescriptionUpdateScreen({Key? key}) : super(key: key);

  @override
  State<DescriptionUpdateScreen> createState() =>
      _DescriptionUpdateScreenState();
}

class _DescriptionUpdateScreenState extends State<DescriptionUpdateScreen> {
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
            const Text("Modification de la description de votre boutique."),
            const SizedBox(
              height: 10,
            ),
            InputComposant(
              hintText: account.accountdata.value!.description,
              nomText: 'Description',
              minLines: 3,
              controller: nom,
            ),
            ElevatedButton(
                onPressed: () {
                  if (nom.text.isNotEmpty) {
                    DatafirestoreService.data_firestore_account
                        .doc(account.accountdata.value!.accountuid)
                        .update({"description": nom.text});
                    ShowMessageComposant.messagesucces(
                        context, "Description modifiée avec succès");
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
