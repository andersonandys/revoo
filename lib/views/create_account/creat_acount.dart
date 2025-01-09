import 'package:Expoplace/composant/input_composant.dart';
import 'package:Expoplace/main.dart';
import 'package:Expoplace/models/account_model.dart';
import 'package:Expoplace/service/datafirestore_service.dart';
import 'package:Expoplace/service/preferences_helper.dart';
import 'package:Expoplace/views/creat_account/account_informartion_screen.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CreatAcount extends StatefulWidget {
  const CreatAcount({Key? key}) : super(key: key);

  @override
  _CreatAcountState createState() => _CreatAcountState();
}

class _CreatAcountState extends State<CreatAcount> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ConfirmpasswordController =
      TextEditingController();
  bool nameIsExist = false;
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
                'Nous vous prions de remplir les information pour la création de votre compte',
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
              if (nameIsExist)
                const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text(
                    "Ce numéro est déjà utilisé, connectez-vous si c'est votre numéro de téléphone.",
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.justify,
                  ),
                ),
              InputComposant(
                controller: passwordController,
                hintText: "Votre mot de passe",
                nomText: 'Mot de passe',
                minLines: 1,
                istexte: true,
                obscureText: true,
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
                enable: true,
                controller: ConfirmpasswordController,
                hintText: "Confirmation mot de passe",
                nomText: 'Confirmation',
                minLines: 1,
                istexte: true,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez confirmer votre mot de passe';
                  }
                  if (value != passwordController.text) {
                    return 'Les mots de passe ne correspondent pas';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
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
                      if (await checkNameExist(numeroController.text)) {
                        return;
                      } else {
                        var uuid = const Uuid();
                        String uid = uuid.v4();
                        print(uid);
                        createCompte(uid);
                      }
                    }
                  },
                  child: const Text(
                    "Creer mon compte",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
            ],
          )),
    );
  }

  Future<bool> checkNameExist(String namedata) async {
    try {
      var querySnapshot = await DatafirestoreService.data_firestore_account
          .where("number", isEqualTo: namedata)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          nameIsExist = true;
        });
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
    return nameIsExist;
  }

  createCompte(uid) async {
    await PreferencesHelper.setUid(uid);
    globalUid = uid;

    DatafirestoreService.data_firestore_account.doc(uid).set(
          AccountModel(
                  name: "",
                  description: "",
                  avatar: "",
                  localisation: "",
                  lienstore: "",
                  position: "",
                  nbremployer: 0,
                  number: numeroController.text,
                  accountuid: uid,
                  offre: 'basic',
                  nbreproduit: 0,
                  nbrereque: 0,
                  nbrevente: 0,
                  affiche: "",
                  expire: "",
                  mdp: passwordController.text,
                  nbrevisite: 0)
              .toJson(),
        );
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const AccountInformartionScreen(),
      ),
    );
    numeroController.clear();
    passwordController.clear();
    ConfirmpasswordController.clear();
  }
}
