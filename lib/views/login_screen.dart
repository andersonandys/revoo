import 'package:Expoplace/views/create_account/creat_acount.dart';
import 'package:Expoplace/views/create_account/logins.dart';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';

import 'package:Expoplace/controllers/accoun_controller.dart';

import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String desc =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry.";

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
                  margin: const EdgeInsets.only(top: 35, left: 10, right: 10),
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
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              fixedSize:
                                  Size(MediaQuery.of(context).size.width, 50),
                              backgroundColor: const Color(0xff0D3B66)),
                          onPressed: () {
                            Get.bottomSheet(
                                isScrollControlled: true,
                                const SingleChildScrollView(
                                  child: Wrap(
                                    children: [Logins()],
                                  ),
                                ));
                          },
                          child: const Text(
                            "Connectez-vous",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            side:
                                const BorderSide(color: Colors.black, width: 1),
                            fixedSize:
                                Size(MediaQuery.of(context).size.width, 50),
                          ),
                          onPressed: () {
                            Get.bottomSheet(
                                isScrollControlled: true,
                                const SingleChildScrollView(
                                  child: Wrap(
                                    children: [CreatAcount()],
                                  ),
                                ));
                            ;
                          },
                          child: const Text(
                            "Inscrivez-vous",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
