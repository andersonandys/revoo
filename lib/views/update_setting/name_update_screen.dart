import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Expoplace/composant/input_composant.dart';
import 'package:Expoplace/composant/show_message_composant.dart';
import 'package:Expoplace/controllers/accoun_controller.dart';
import 'package:Expoplace/service/datafirestore_service.dart';

class NameUpdateScreen extends StatefulWidget {
  NameUpdateScreen({Key? key}) : super(key: key);

  @override
  State<NameUpdateScreen> createState() => _NameUpdateScreenState();
}

class _NameUpdateScreenState extends State<NameUpdateScreen> {
  final nom = TextEditingController();

  final account = Get.put(AccounController());
  final key = GlobalKey<FormState>();
  bool nameIsExist = false;
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                height: 5,
                width: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
                "En modifiant le nom de votre boutique cela va impacter le lien de votre boutique ainsi que la disponibilité du lien que vous avez partage avec vos clients."),
            const SizedBox(
              height: 10,
            ),
            InputComposant(
              hintText: account.accountdata.value!.name,
              nomText: 'Nom boutique',
              minLines: 1,
              controller: nom,
              onFieldSubmitted: (value) =>
                  checkNameExist(value), // Appelé après la soumission
              onChanged: (value) {
                if (value.isNotEmpty) {
                  checkNameExist(value); // Vérification en temps réel
                }
              },
              onEditingCompletes: () => checkNameExist(nom.text),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer le nom de votre boutique';
                }
                return null;
              },
            ),
            if (nameIsExist)
              const Padding(
                padding: EdgeInsets.all(1.0),
                child: Text(
                  "Ce nom est déjà utilisé",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  if (nom.text.isNotEmpty) {
                    DatafirestoreService.data_firestore_account
                        .doc(account.accountdata.value!.accountuid)
                        .update({
                      "name": nom.text,
                      "lienstore": nom.text.replaceAll(" ", "_").toLowerCase()
                    });
                    ShowMessageComposant.messagesucces(context,
                        "Nom de la boutique a été modifié avec succès.");
                    Navigator.pop(context);
                  }
                },
                child: const Text("Modifier"))
          ],
        ),
      ),
    );
  }

  Future<void> checkNameExist(String namedata) async {
    try {
      var querySnapshot = await DatafirestoreService.data_firestore_account
          .where("name", isEqualTo: namedata)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          nameIsExist = true;
        });
        nom.clear();
      } else {
        setState(() {
          nameIsExist = false;
        });
      }
    } catch (e) {
      setState(() {
        nameIsExist = false;
      });
    }
  }
}
