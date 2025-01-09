import 'package:Expoplace/service/datafirestore_service.dart';
import 'package:flutter/material.dart';
import 'package:Expoplace/controllers/creat_account_controller.dart';
import 'package:Expoplace/composant/input_composant.dart';
import 'package:get/get.dart';

class CreatStep1Screen extends StatefulWidget {
  final CreatAccountController controller;
  CreatStep1Screen({super.key, required this.controller});

  @override
  State<CreatStep1Screen> createState() => _CreatStep1ScreenState();
}

class _CreatStep1ScreenState extends State<CreatStep1Screen> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Form(
          key: widget.controller.globalkey.value,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              InputComposant(
                hintText: 'Nom de votre boutique',
                nomText: 'Nom boutique',
                minLines: 1,
                controller: widget.controller.nomController,
                onFieldSubmitted: (value) =>
                    checkNameExist(value), // Appelé après la soumission
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    checkNameExist(value); // Vérification en temps réel
                  }
                },
                onEditingCompletes: () =>
                    checkNameExist(widget.controller.nomController.text),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom de votre boutique';
                  }
                  return null;
                },
              ),
              (widget.controller.existname.isTrue)
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Ce nom est déjà utilisé",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  : Container(),
              InputComposant(
                hintText: "Nombre d'employés",
                nomText: 'Nombre de vos employés',
                minLines: 1,
                istexte: false,
                controller: widget.controller.employeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nombre d\'employés';
                  }
                  return null;
                },
              ),
              InputComposant(
                hintText: 'Description',
                nomText: 'Description de votre boutique',
                minLines: 3,
                controller: widget.controller.descriptionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
            ],
          ),
        ));
  }

  Future<void> checkNameExist(String namedata) async {
    try {
      var querySnapshot = await DatafirestoreService.data_firestore_account
          .where("name", isEqualTo: namedata)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        widget.controller.existname.value = true;
      } else {
        widget.controller.existname.value = false;
      }
    } catch (e) {
      widget.controller.existname.value = true;
    }
  }
}
