import 'package:flutter/material.dart';

class CreatStep3Screen extends StatelessWidget {
  const CreatStep3Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              "assets/succes.png",
              height: 200,
              width: 200,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text(
              "Bienvenue chez ExpoPlace 🎉",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xff0D3B66),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Votre compte a été créé avec succès ! Nous sommes ravis de vous accueillir dans notre communauté. Explorez les fonctionnalités de ExpoPlace et commencez à transformer votre boutique en ligne dès maintenant.",
              style: TextStyle(fontSize: 18, color: Colors.black54),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
