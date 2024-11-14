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
            child: Image.asset("assets/succes.png"),
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
              child: Text(
            "Lorem Ipsum",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          )),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.justify),
          )
        ],
      ),
    );
  }
}
