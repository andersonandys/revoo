import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:revoo/controllers/creat_account_controller.dart';

class stepComposant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Largeur totale de l'écran
    double screenWidth = MediaQuery.of(context).size.width;

    // Largeur des CircleAvatar (60 chacun, car le rayon est de 30)
    double avatarWidth = 60 * 3;

    // Calcul de la largeur totale disponible pour les Container
    double availableWidth = screenWidth - avatarWidth;

    // Largeur des Container divisée par 2 (car il y a 2 Container)
    double containerWidth = availableWidth / 3;
    final step = Get.find<CreatAccountController>().step_account;
    return Obx(() => Container(
          color: Colors.white,
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.yellow),
                      borderRadius: BorderRadius.circular(100),
                      color: (step.value == 0) ? Colors.yellow : Colors.white),
                  child: const Icon(Iconsax.buildings, size: 30),
                ),
              ),
              Container(
                height: 10,
                width: containerWidth,
                color: const Color(0xffF2F2F2),
              ),
              GestureDetector(
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.yellow),
                      borderRadius: BorderRadius.circular(100),
                      color: (step.value == 1) ? Colors.yellow : Colors.white),
                  child: const Icon(
                    Icons.medical_information_outlined,
                    size: 30,
                  ),
                ),
              ),
              Container(
                height: 10,
                width: containerWidth,
                color: const Color(0xffF2F2F2),
              ),
              GestureDetector(
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.yellow),
                      borderRadius: BorderRadius.circular(100),
                      color: (step.value == 2) ? Colors.yellow : Colors.white),
                  child: const Icon(
                    Icons.check,
                    size: 40,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
