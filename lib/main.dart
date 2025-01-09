import 'package:Expoplace/service/preferences_helper.dart';

import 'package:firebase_app_check/firebase_app_check.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Expoplace/views/loadpage_screen.dart';
import 'package:Expoplace/views/login_screen.dart';

String? globalUid;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  // Chargez l'UID au démarrage
  globalUid = await PreferencesHelper.getUid();
  // configuration apptchek
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle:
                      const TextStyle(fontSize: 20, color: Color(0xff0D3B66)),
                  fixedSize: Size(MediaQuery.of(context).size.width, 60),
                  backgroundColor: const Color(0xffFFCF0D)))),
      home: (globalUid != null) ? const LoadpageScreen() : const LoginScreen(),
    );
  }
}


  // Map<String, dynamic>? checkIfCodeExists(String code) {
  //   // Find the room that matches the code
  //   final room = rooms.firstWhere(
  //     (room) => room.code == code,
  //   );

  //   // If the room exists, return its UID and a flag indicating success
  //   if (room != null) {
  //     return {
  //       'exists': true,
  //       'uid': room.uidroom,
  //       "nombrep": room.nombrep,
  //       "players": room.players
  //       // Assuming room has a 'uid' field
  //     };
  //   } else {
  //     // If no room with the given code is found, return exists as false
  //     return {
  //       'exists': false,
  //       'uid': null,
  //     };
  //   }
  // }