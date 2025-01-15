import 'package:Expoplace/composant/input_composant.dart';
import 'package:Expoplace/controllers/creat_account_controller.dart';
import 'package:Expoplace/main.dart';
import 'package:Expoplace/models/account_model.dart';
import 'package:Expoplace/service/datafirestore_service.dart';
import 'package:Expoplace/service/preferences_helper.dart';
import 'package:Expoplace/views/creat_accountShop/account_informartion_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final GlobalKey<FormState> formKeyInscription = GlobalKey<FormState>();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController colorfavorisController = TextEditingController();
  final createController = Get.put(CreatAccountController());
  bool nameExists = false;
  bool load = false;
  var uid = const Uuid();
  String secureColor = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKeyInscription,
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
                const SizedBox(height: 20),
                const Text(
                  'Veuillez remplir les informations pour la création de votre compte.',
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 20),
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
                if (nameExists)
                  const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      "Ce numéro est déjà utilisé. Connectez-vous si c'est votre numéro de téléphone.",
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                InputComposant(
                  controller: passwordController,
                  hintText: "Votre mot de passe",
                  nomText: 'Mot de passe',
                  minLines: 1,
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
                  controller: confirmPasswordController,
                  hintText: "Confirmation mot de passe",
                  nomText: 'Confirmation',
                  minLines: 1,
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
                const SizedBox(height: 10),
                const Text(
                  'Question de sécurité',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const Text(
                    'Cette question va être utilisée pour la revitalisation de votre mot de passe.'),
                InputComposant(
                  onChanged: (value) {
                    secureColor =
                        colorfavorisController.text + uid.v4().substring(0, 4);
                    setState(() {});
                  },
                  enable: true,
                  controller: colorfavorisController,
                  hintText: "Votre couleur favorite",
                  nomText: 'Couleur favorite',
                  minLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir une couleur.';
                    }
                    return null;
                  },
                ),
                if (colorfavorisController.text.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'votre couleur devient : ',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        secureColor,
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    fixedSize: Size(MediaQuery.of(context).size.width, 60),
                    backgroundColor: const Color(0xffFFCF0D),
                  ),
                  onPressed: () async {
                    if (formKeyInscription.currentState!.validate()) {
                      if (await checkNameExists(numeroController.text)) {
                        return;
                      } else {
                        var uuid = const Uuid();
                        String uid = uuid.v4();
                        createAccount(uid);
                      }
                    }
                  },
                  child: (load)
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Créer mon compte",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Future<bool> checkNameExists(String namedata) async {
    setState(() {
      load = true;
    });
    try {
      var querySnapshot = await DatafirestoreService.data_firestore_account
          .where("number", isEqualTo: namedata)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          nameExists = true;
          load = false;
        });
      } else {
        setState(() {
          nameExists = false;
        });
      }
    } catch (e) {
      setState(() {
        nameExists = false;
      });
    }
    return nameExists;
  }

  Future<void> createAccount(String uid) async {
    setState(() {
      load = true;
    });
    await PreferencesHelper.setUid(uid);
    globalUid = uid;
    createController.numero_controller.text = numeroController.text;
    DatafirestoreService.data_firestore_account.doc(uid).set(
          AccountModel(
            name: "",
            description: "",
            avatar: "",
            localisation: "",
            lienstore: "",
            position: "",
            typeEmplacementShop: "",
            number: numeroController.text,
            accountuid: uid,
            offre: '',
            nbreproduit: 0,
            nbrereque: 0,
            nbrevente: 0,
            affiche: "",
            expire: "",
            mdp: passwordController.text,
            nbrevisite: 0,
            colorfavoris: secureColor,
          ).toJson(),
        );
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const AccountInformartionScreen(),
        ));

    numeroController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    setState(() {
      load = false;
    });
  }
}
