import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:revoo/composant/input_composant.dart';
import 'package:revoo/controllers/creat_account_controller.dart';
import 'package:revoo/service/localisation_service.dart';

class CreatStep2Screen extends StatelessWidget {
  final CreatAccountController controller;
  CreatStep2Screen({Key? key, required this.controller}) : super(key: key);
  final LocationService _locationService = LocationService();
  Position? _currentPosition;

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
            const Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.black,
                  ),
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: CircleAvatar(
                      backgroundColor: Color(0xffF5F5F5),
                      child: Icon(Iconsax.camera, color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InputComposant(
              hintText: 'Votre numéro whatsapp',
              nomText: 'Numero whatsapp',
              minLines: 1,
              istexte: false,
              controller: controller.numero_controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre numero whatsapp';
                }
                return null;
              },
            ),
            const Text(
              "Localisation",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Cliquer sur l’icone pour octroyer votre localisation",
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: InputComposant(
                      hintText: 'Cocody',
                      nomText: "",
                      minLines: 1,
                      enable: false,
                      controller: controller.localisation_controller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez selectionner votre localisation';
                        }
                        return null;
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: _getLocationAndAddress,
                    child: const CircleAvatar(
                      backgroundColor: Color(0xffF5F5F5),
                      radius: 25,
                      child: Icon(
                        Icons.location_on,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ),
            InputComposant(
              hintText:
                  "https://www.google.com/${controller.nomController.text}",
              nomText: "Lien store",
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
}
