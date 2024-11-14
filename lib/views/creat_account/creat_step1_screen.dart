import 'package:flutter/material.dart';
import 'package:revoo/controllers/creat_account_controller.dart';
import 'package:revoo/composant/input_composant.dart';

class CreatStep1Screen extends StatelessWidget {
  final CreatAccountController controller;
  CreatStep1Screen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.globalkey.value,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          InputComposant(
            hintText: 'Nom de votre boutique',
            nomText: 'Nom organisation',
            minLines: 1,
            controller: controller.nomController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer le nom de votre boutique';
              }
              return null;
            },
          ),
          InputComposant(
            hintText: 'Nombre employe',
            nomText: 'Nombre de vos employes',
            minLines: 1,
            istexte: false,
            controller: controller.employeController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer le nombre d\'employés';
              }
              return null;
            },
          ),
          InputComposant(
            hintText: 'Description',
            nomText: 'Description de votre organisation',
            minLines: 3,
            controller: controller.descriptionController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer une description';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
