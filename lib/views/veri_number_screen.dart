import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Expoplace/controllers/accoun_controller.dart';
import 'package:Expoplace/controllers/creat_account_controller.dart';
import 'package:Expoplace/service/datafirestore_service.dart';
import 'package:Expoplace/views/creat_account/account_informartion_screen.dart';
import 'package:Expoplace/views/home_screen.dart';
import 'package:Expoplace/views/loadpage_screen.dart';
import 'package:Expoplace/views/menu/home_menu.dart';

class OtpVerificationPage extends StatefulWidget {
  final String verificationId;
  const OtpVerificationPage({Key? key, required this.verificationId})
      : super(key: key);

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _otpController = TextEditingController();
  String desc = "Lorem Ipsum is simply dummy ";
  final focusNode = FocusNode();
  int _seconds = 120; // 2 minutes en secondes
  late Timer _timer;
  var load = false.obs;
  final accouncontroller = Get.put(CreatAccountController());
  final accoun = Get.put(AccounController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        _timer.cancel(); // Arrêter le timer lorsque le temps est écoulé
      }
    });
  }

  String get _timerString {
    String minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    String seconds = (_seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _otpController.dispose();
    focusNode.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _verifyOtp() async {
    if (_otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text("nous vous prions de saisir le code"),
      ));
    } else {
      load.value = true;
      String smsCode = _otpController.text.trim();
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: smsCode,
      );

      try {
        UserCredential dataaccount =
            await _auth.signInWithCredential(credential);
        accoun.accountuid.value = dataaccount.user!.uid;

        var querySnapshot = await DatafirestoreService.data_firestore_account
            .where("number", isEqualTo: accouncontroller.numero_controller.text)
            .get();
        if (querySnapshot.docs.isEmpty) {
          // Aucun compte trouvé
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) =>
                  const AccountInformartionScreen(),
            ),
          );
        } else {
          // Un ou plusieurs comptes trouvés
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const LoadpageScreen(),
            ),
          );
        }

        load.value = false;
      } catch (e) {
        load.value = false;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.redAccent,
          content:
              Text("Code incorrecte, nous vous prions de saisir le bon code"),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 64,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(70, 69, 66, 1),
      ),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(232, 235, 241, 0.37),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final cursor = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 21,
        height: 1,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(137, 146, 160, 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Image.asset("assets/otp1.png"),
                  ],
                ),
              )),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        "Vérification",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Nous avons envoyer un code de vérification sur votre numéro de téléphone",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 30),
                      Pinput(
                          focusNode: focusNode,
                          length: 6,
                          controller: _otpController,
                          onSubmitted: (pin) => _verifyOtp(),
                          defaultPinTheme: defaultPinTheme,
                          separatorBuilder: (index) =>
                              const SizedBox(width: 16),
                          pinputAutovalidateMode:
                              PinputAutovalidateMode.onSubmit,
                          showCursor: true,
                          cursor: cursor,
                          focusedPinTheme: defaultPinTheme.copyWith(
                            decoration: BoxDecoration(
                              color: const Color(0xff0D3B66),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(
                                      0, 0, 0, 0.05999999865889549),
                                  offset: Offset(0, 3),
                                  blurRadius: 16,
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          onPressed: () => Get.back(),
                          child: const Text("Modifier le numero")),
                      const SizedBox(height: 20),
                      Text("Expiration du code dans : $_timerString")
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _verifyOtp(),
                child: (load.isTrue)
                    ? const CircularProgressIndicator(
                        color: Color(0xff0D3B66),
                      )
                    : const Text(
                        "Continuer",
                        style:
                            TextStyle(fontSize: 20, color: Color(0xff0D3B66)),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
