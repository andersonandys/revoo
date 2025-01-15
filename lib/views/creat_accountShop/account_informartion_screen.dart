import 'package:Expoplace/composant/show_message_composant.dart';
import 'package:Expoplace/controllers/creat_account_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Expoplace/composant/step_account_composant.screen.dart';
import 'package:Expoplace/views/creat_accountShop/creat_step1_screen.dart';
import 'package:Expoplace/views/creat_accountShop/creat_step2_screen.dart';
import 'package:Expoplace/views/creat_accountShop/creat_step3_screen.dart';

class AccountInformartionScreen extends StatefulWidget {
  const AccountInformartionScreen({Key? key}) : super(key: key);

  @override
  _AccountInformartionScreenState createState() =>
      _AccountInformartionScreenState();
}

class _AccountInformartionScreenState extends State<AccountInformartionScreen> {
  final creatController = Get.put(CreatAccountController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () => SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        stepComposant(),
                        const SizedBox(height: 20),
                        if (creatController.step_account.value != 2)
                          const Text(
                            "Information du compte",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                        if (creatController.step_account.value == 0)
                          CreatStep1Screen(controller: creatController),
                        if (creatController.step_account.value == 1)
                          CreatStep2Screen(controller: creatController),
                        if (creatController.step_account.value == 2)
                          CreatStep3Screen(),
                      ],
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Vérifie si l'étape 1 est validée avant de passer à l'étape suivante
                  switch (creatController.step_account.value) {
                    case 0:
                      final step1Form = creatController
                          .globalkey.value.currentState!
                          .validate();
                      if (step1Form && creatController.existname.isFalse) {
                        if (creatController.isphisycshopController.value ==
                            "") {
                          ShowMessageComposant.message(context,
                              "Vous nous prions de sélection l'emplacement de votre boutique.");
                        } else {
                          creatController.step_account.value++;
                        }
                      } else {
                        creatController.existname.value = true;
                      }
                      break;
                    case 1:
                      final step2Form = creatController
                          .globalkey.value.currentState!
                          .validate();

                      if (step2Form) {
                        if (creatController.avatar.value.isNotEmpty) {
                          creatController.step_account.value++;
                        } else {
                          ShowMessageComposant.message(
                              context, "Vous devez ajouter votre logo.");
                        }
                      }
                      break;
                    case 2:
                      creatController.addacount(context);
                      break;
                    default:
                  }
                },
                child: const Text("Continuer"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
