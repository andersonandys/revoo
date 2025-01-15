import 'package:Expoplace/composant/input_composant.dart';
import 'package:Expoplace/composant/show_message_composant.dart';
import 'package:Expoplace/controllers/creat_account_controller.dart';
import 'package:Expoplace/main.dart';
import 'package:Expoplace/service/preferences_helper.dart';
import 'package:Expoplace/views/loadpage_screen.dart';
import 'package:flutter/material.dart';
import 'package:Expoplace/service/datafirestore_service.dart';
import 'package:get/get.dart';

class Forgermdp extends StatefulWidget {
  const Forgermdp({Key? key}) : super(key: key);

  @override
  _LoginsState createState() => _LoginsState();
}

class _LoginsState extends State<Forgermdp> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController nameshopController = TextEditingController();
  final TextEditingController colorfavorisController = TextEditingController();
  final TextEditingController newMdpcontroller = TextEditingController();
  final TextEditingController newMdpConfirmcontroller = TextEditingController();
  var load = false.obs;
  String errorMessage = "";
  final creatController = Get.put(CreatAccountController());
  var step = 1.obs;
  var uidCompte = "".obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Obx(
            () => Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(1),
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xffFFCF0D),
                            border: Border.all(
                              color: const Color(0xffFFCF0D),
                              width: 1,
                            ),
                            image: const DecorationImage(
                                image: AssetImage("assets/logo.png"))),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Vous avez oublié votre mot de passe ? ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Ce n'est pas graves, nous allons vous aider à recréer un nouveau mot de passe en deux étapes.\n Nous vous prions de remplir les informations suivantes.",
                      style: TextStyle(fontSize: 17),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (step.value == 1)
                      Column(
                        children: <Widget>[
                          InputComposant(
                            istexte: false,
                            controller: numeroController,
                            hintText: "Votre numéro de téléphone",
                            nomText: 'Numéro',
                            minLines: 1,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre numéro de téléphone';
                              }
                              return null;
                            },
                          ),
                          InputComposant(
                            controller: nameshopController,
                            hintText: "Nom de votre boutique",
                            nomText: 'Boutique',
                            minLines: 1,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre mot de passe';
                              }
                              return null;
                            },
                          ),
                          InputComposant(
                            controller: colorfavorisController,
                            hintText: "Votre couleur favorite",
                            nomText: 'Couleur favorite',
                            minLines: 1,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre mot de passe';
                              }
                              return null;
                            },
                          )
                        ],
                      ),
                    if (step.value == 2)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Enregistrement du nouveau mot de passe.",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InputComposant(
                            controller: newMdpcontroller,
                            obscureText: true,
                            hintText: "Nouveau mot de passe",
                            nomText: 'Mot de passe',
                            minLines: 1,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer un mot de passe';
                              }
                              if (value.length < 6) {
                                return 'Le mot de passe doit contenir au moins 6 caractères';
                              }
                              if (!value.contains(RegExp(r'[0-9]'))) {
                                return 'Le mot de passe doit contenir au moins un chiffre';
                              }
                              if (!value.contains(RegExp(r'[A-Za-z]'))) {
                                return 'Le mot de passe doit contenir au moins une lettre';
                              }
                              return null;
                            },
                          ),
                          InputComposant(
                            obscureText: true,
                            controller: newMdpConfirmcontroller,
                            hintText: "Confirmer votre mot de passe",
                            nomText: 'Confirmation',
                            minLines: 1,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez confirmer votre mot de passe';
                              }
                              if (value != newMdpcontroller.text) {
                                return "Les deux mots de passe ne correspondent pas.";
                              }
                              return null;
                            },
                          )
                        ],
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            fixedSize:
                                Size(MediaQuery.of(context).size.width, 60),
                            backgroundColor: const Color(0xffFFCF0D)),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            load.value = true;
                            if (step.value == 1) {
                              bool isValid = await checkCredentials(
                                  numeroController.text,
                                  nameshopController.text,
                                  colorfavorisController.text);

                              if (isValid) {
                                load.value = false;
                                step.value = 2;
                              } else {
                                load.value = false;
                                ShowMessageComposant.message(context,
                                    "Oups, nous n'avons pas trouvé d'informations qui correspondent aux données que vous avez transmises.");
                              }
                            } else {
                              updateMdp();
                            }
                          }
                        },
                        child: (load.isTrue)
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                (step.value == 1) ? "Suivant" : "Terminer",
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              )),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Future<bool> checkCredentials(
      String number, String nameshop, String colorfavoris) async {
    load.value = true;
    try {
      var querySnapshot = await DatafirestoreService.data_firestore_account
          .where("number", isEqualTo: number)
          .where("name", isEqualTo: nameshop)
          .where("colorfavoris", isEqualTo: colorfavoris)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        await PreferencesHelper.setUid(querySnapshot.docs.first["accountuid"]);

        uidCompte.value = querySnapshot.docs.first["accountuid"];
        return true; // Les informations sont correctes
      }
    } catch (e) {
      print("Erreur lors de la vérification des informations : $e");
    }

    return false; // Les informations ne correspondent pas
  }

  updateMdp() {
    globalUid = uidCompte.value;
    DatafirestoreService.data_firestore_account
        .doc(uidCompte.value)
        .update({"mdp": newMdpcontroller.text});
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const LoadpageScreen(),
        ));
    load.value = false;
  }
}
