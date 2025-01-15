import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Expoplace/composant/input_composant.dart';
import 'package:Expoplace/composant/show_message_composant.dart';
import 'package:Expoplace/composant/step_account_composant.screen.dart';
import 'package:Expoplace/controllers/creat_account_controller.dart';
import 'package:Expoplace/service/datafirestore_service.dart';
import 'package:Expoplace/service/localisation_service.dart';

class CreatStep2Screen extends StatelessWidget {
  final CreatAccountController controller;
  CreatStep2Screen({Key? key, required this.controller}) : super(key: key);
  final LocationService _locationService = LocationService();
  Position? _currentPosition;
  var load = false.obs;
  final _picker = ImagePicker();
  final creatController = Get.put(CreatAccountController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Form(
        key: controller.globalkey.value,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Obx(
              () => Stack(
                children: [
                  Container(
                    height: 130,
                    width: 130,
                    decoration: BoxDecoration(
                        image: (creatController.avatar.isNotEmpty)
                            ? DecorationImage(
                                image: NetworkImage(
                                  creatController.avatar.value,
                                ),
                                fit: BoxFit.cover)
                            : null,
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: (load.isTrue)
                        ? const CircularProgressIndicator(color: Colors.white)
                        : GestureDetector(
                            onTap: () => selectlogo(context),
                            child: const CircleAvatar(
                              backgroundColor: Color(0xffF5F5F5),
                              child: Icon(Iconsax.camera, color: Colors.black),
                            ),
                          ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Numéro WhatsApp",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Enregistrez le numéro WhatsApp que vous utilisez pour votre boutique.",
            ),
            InputComposant(
              hintText: 'Votre numéro whatsapp',
              nomText: '',
              enable: false,
              minLines: 1,
              istexte: false,
              controller: controller.numero_controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre numéro whatsapp';
                }
                return null;
              },
            ),
            InputComposant(
              hintText: 'Exemple : Cocody',
              nomText: "Localisation",
              minLines: 1,
              istexte: true,
              controller: controller.localisation_controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez selectionner votre localisation';
                }
                return null;
              },
            ),
            InputComposant(
              hintText:
                  "https://exploplace.shop/${controller.nomController.text.toLowerCase().replaceAll(" ", "_")}",
              nomText: "Lien de votre boutique",
              minLines: 1,
              controller: controller.lienstotre_controller,
              enable: false,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getLocationAndAddress() async {
    final position = await _locationService.getCurrentPosition();
    if (position != null) {
      final address =
          await _locationService.getAddressFromCoordinates(position);
      controller.position_localisation.value = position.toString();
      controller.localisation_controller.text = address!;
    }
  }

  selectlogo(context) async {
    final XFile? images = await _picker.pickImage(source: ImageSource.gallery);

    if (images != null) {
      load.value = true;
      try {
        // Convertir XFile en File
        File imageFile = File(images.path);

        String fileName =
            'products/${DateTime.now().millisecondsSinceEpoch}_${images.path.split('/').last}';
        UploadTask uploadTask =
            FirebaseStorage.instance.ref().child(fileName).putFile(imageFile);

        TaskSnapshot snapshot = await uploadTask;
        String lien = await snapshot.ref.getDownloadURL();

        // Mise à jour de Firestore avec le lien de l'image
        creatController.avatar.value = lien;
        load.value = false;
      } catch (e) {
        ShowMessageComposant.message(
            context, "Erreur lors du téléchargement de l'image");
        throw e;
      }
    } else {
      load.value = false;
      ShowMessageComposant.message(
          context, "Vous devez sélectionner au moins, une image.");
    }
  }
}
