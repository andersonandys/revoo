import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:Expoplace/composant/show_message_composant.dart';
import 'package:Expoplace/controllers/accoun_controller.dart';
import 'package:Expoplace/models/account_model.dart';
import 'package:Expoplace/service/datafirestore_service.dart';
import 'package:Expoplace/views/creat_account/account_informartion_screen.dart';
import 'package:Expoplace/views/loadpage_screen.dart';
import 'package:Expoplace/views/otp_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String desc =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry.";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  var load = false.obs;
  final account = Get.put(AccounController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Image.asset("assets/login1.png"),
          ),
          ClipPath(
            clipper: OvalTopBorderClipper(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              color: const Color(0xffFFCF0D),
              child: Container(
                  margin: const EdgeInsets.only(top: 50, left: 10, right: 10),
                  child: Column(
                    children: [
                      const Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Connectez-vous",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Accédez à votre compte et commencez à profiter des fonctionnalités exclusives de ExpoPlace.",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      )),
                      Obx(
                        () => ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fixedSize:
                                    Size(MediaQuery.of(context).size.width, 60),
                                backgroundColor: const Color(0xff0D3B66)),
                            onPressed: () {
                              signInWithGoogle();
                            },
                            child: (load.value)
                                ? const CircularProgressIndicator(
                                    color: Color(0xffFFCF0D),
                                  )
                                : const Text(
                                    "Connexion avec Google",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  )),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  // Méthode de connexion par Google
  Future<User?> signInWithGoogle() async {
    load.value = true;
    try {
      // Lancer le flux de connexion Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // L'utilisateur a annulé la connexion
        load.value = false;
        ShowMessageComposant.message(
            context, "Connexion annulée par l'utilisateur");
        return null;
      }

      // Obtenir les informations d'authentification Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Créer des credentials pour Firebase avec le jeton Google
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Se connecter à Firebase avec les credentials Google
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Vérification des informations de l'utilisateur connecté
      User? user = userCredential.user;
      if (user != null) {
        account.getdataAccount();
        final userDoc =
            DatafirestoreService.data_firestore_account.doc(user.uid);

        // Récupère le document de l'utilisateur pour vérifier s'il existe
        final docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
          DatafirestoreService.data_firestore_account
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set(
                AccountModel(
                        name: "",
                        description: "",
                        avatar: "",
                        localisation: "",
                        lienstore: "",
                        position: "",
                        nbremployer: 0,
                        number: "",
                        accountuid: FirebaseAuth.instance.currentUser!.uid,
                        offre: 'basic',
                        nbreproduit: 0,
                        nbrereque: 0,
                        nbrevente: 0,
                        affiche: "",
                        expire: "",
                        nbrevisite: 0)
                    .toJson(),
              );
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) =>
                  const AccountInformartionScreen(),
            ),
          );
        } else {
          if (account.accountdata.value!.name != "") {
            load.value = false;
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const LoadpageScreen(),
              ),
            );
          } else {
            load.value = false;
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) =>
                    const AccountInformartionScreen(),
              ),
            );
          }
        }

        load.value = false;
        return user;
      }

      return null;
    } catch (e) {
      load.value = false;
      ShowMessageComposant.message(
          context, "Erreur lors de la connexion, ressayer plus tard");
      print("Erreur lors de la connexion avec Google : $e");
      print(e);
      return null;
    }
  }
}
