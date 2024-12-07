import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:Expoplace/controllers/creat_account_controller.dart';
import 'package:Expoplace/views/veri_number_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String desc =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,";

  String _phoneNumber = '';
  String _verificationId = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final accoun_controller = Get.put(CreatAccountController());
  var load = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(child: Image.asset("assets/otp.png")),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(desc),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Numero",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IntlPhoneField(
                          // ignore: deprecated_member_use
                          searchText: "Rechercher votre pays",
                          invalidNumberMessage: "Numéro invalide",
                          decoration: InputDecoration(
                              fillColor: Color(0xffF5F5F5),
                              filled: true,
                              labelText: 'Numéro de téléphone',
                              border: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              )),
                          initialCountryCode: 'CI',
                          onChanged: (phone) {
                            _phoneNumber = phone.completeNumber;
                            accoun_controller.numero_controller.text =
                                _phoneNumber;
                          },
                        ),
                      ),
                    ],
                  ),
                )),
                ElevatedButton(
                    onPressed: _verifyPhoneNumber,
                    child: (load.isTrue)
                        ? const CircularProgressIndicator(
                            color: Color(0xff0D3B66),
                          )
                        : const Text(
                            "Continuer",
                            style: TextStyle(
                                fontSize: 20, color: Color(0xff0D3B66)),
                          ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _verifyPhoneNumber() async {
    if (_phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text("Rentrer votre numero de telephone"),
      ));
    } else {
      load.value = true;
      await _auth.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          // Connexion automatique réussie
          // Navigator.of(context).pushReplacementNamed('/home');
          print("Connexion auto is ready");
          load.value = false;
        },
        verificationFailed: (FirebaseAuthException e) {
          // Gérer les erreurs de vérification
          if (e.code == 'invalid-phone-number') {
            load.value = false;
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text("Numéro de téléphone invalide."),
            ));
          } else {
            load.value = false;
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text("Une erreure c est produite, ressayer plustard"),
            ));
            print(e.message);
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
          });
          load.value = false;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OtpVerificationPage(
                verificationId: verificationId,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    }
  }
}
