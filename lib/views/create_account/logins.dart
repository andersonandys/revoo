import 'package:Expoplace/composant/input_composant.dart';
import 'package:Expoplace/views/loadpage_screen.dart';
import 'package:flutter/material.dart';
import 'package:Expoplace/service/datafirestore_service.dart';

class Logins extends StatefulWidget {
  const Logins({Key? key}) : super(key: key);

  @override
  _LoginsState createState() => _LoginsState();
}

class _LoginsState extends State<Logins> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool load = false;
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 5,
                width: 50,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Nous vous prions de remplir les informations pour vous connecter',
                style: TextStyle(fontSize: 17),
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
                      fixedSize: Size(MediaQuery.of(context).size.width, 60),
                      backgroundColor: const Color(0xffFFCF0D)),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      load = true;
                      bool isValid = await checkCredentials(
                        numeroController.text,
                        passwordController.text,
                      );
                      if (isValid) {
                        setState(() {
                          errorMessage = "";
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const LoadpageScreen(),
                            ));
                      } else {
                        setState(() {
                          load = false;
                          errorMessage =
                              "Numéro ou mot de passe incorrect. Veuillez réessayer.";
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
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )),
            ],
          )),
    );
  }

  Future<bool> checkCredentials(String number, String password) async {
    try {
      var querySnapshot = await DatafirestoreService.data_firestore_account
          .where("number", isEqualTo: number)
          .where("mdp", isEqualTo: password)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return true; // Les informations sont correctes
      }
    } catch (e) {
      print("Erreur lors de la vérification des informations : $e");
    }
    return false; // Les informations ne correspondent pas
  }
}
