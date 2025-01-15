import 'package:Expoplace/composant/input_composant.dart';
import 'package:Expoplace/composant/show_message_composant.dart';
import 'package:Expoplace/controllers/creat_account_controller.dart';
import 'package:Expoplace/main.dart';
import 'package:Expoplace/service/datafirestore_service.dart';
import 'package:Expoplace/service/preferences_helper.dart';
import 'package:Expoplace/views/create_accountUser/creat_acount.dart';
import 'package:Expoplace/views/create_accountUser/forgerMdp.dart';
import 'package:Expoplace/views/loadpage_screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:Expoplace/controllers/accoun_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool load = false;
  final account = Get.put(AccounController());
  final GlobalKey<FormState> formKeyConnexion = GlobalKey<FormState>();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = "";
  final creatController = Get.put(CreatAccountController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: formKeyConnexion,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    height: 70,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "Bienvenue",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('Heureux de vous revoir !'),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Connectez-vous pour accéder à votre tableau de bord, gérer efficacement votre boutique, et augmenter vos ventes grâce aux outils exclusifs d'ExpoPlace.",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w100,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InputComposant(
                        controller: numeroController,
                        hintText: "Votre numéro de téléphone",
                        nomText: 'Numéro',
                        minLines: 1,
                        istexte: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre numéro de téléphone';
                          }
                          return null;
                        },
                      ),
                      InputComposant(
                        enable: true,
                        controller: passwordController,
                        hintText: "Mot de passe",
                        nomText: 'Mot de passe',
                        minLines: 1,
                        istexte: true,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre mot de passe';
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        const Forgermdp(),
                                  ),
                                );
                              },
                              child: const Row(
                                children: <Widget>[
                                  Text(
                                    "Mot de passe oublié",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.lock,
                                    color: Colors.red,
                                  ),
                                ],
                              ))
                        ],
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
                            if (formKeyConnexion.currentState!.validate()) {
                              setState(() {
                                load = true;
                              });
                              bool isValid = await checkCredentials(
                                numeroController.text,
                                passwordController.text,
                              );
                              if (isValid) {
                                creatController.numero_controller.text =
                                    numeroController.text;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          const LoadpageScreen(),
                                    ));
                              } else {
                                setState(() {
                                  load = false;
                                });
                              }
                            }
                          },
                          child: (load)
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Se connecter",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                )),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Column(
                          children: <Widget>[
                            const Text("Vous n'avez pas de compte ?",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w100,
                                )),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          const CreateAccount(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Créer un compte.",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> checkCredentials(String number, String password) async {
    setState(() {
      load = true;
    });
    try {
      var querySnapshot = await DatafirestoreService.data_firestore_account
          .where("number", isEqualTo: number)
          .where("mdp", isEqualTo: password)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        await PreferencesHelper.setUid(querySnapshot.docs.first["accountuid"]);
        globalUid = querySnapshot.docs.first["accountuid"];
        setState(() {
          globalUid = querySnapshot.docs.first["accountuid"];
        });
        return true; // Les informations sont correctes
      } else {
        ShowMessageComposant.message(
            "Erreur", "Numéro ou mot de passe incorrect. Veuillez réessayer.");
      }
    } catch (e) {
      ShowMessageComposant.message(
          "Erreur", "Une erreur s'est produite. Veuillez réessayer.");
      print("Erreur lors de la vérification des informations : $e");
    }
    setState(() {
      load = false;
    });
    return false; // Les informations ne correspondent pas
  }
}
