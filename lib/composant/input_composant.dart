import 'package:flutter/material.dart';

class InputComposant extends StatelessWidget {
  final String hintText;
  final String nomText;
  final int minLines;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool? enable;
  final bool? istexte;
  InputComposant(
      {Key? key,
      required this.hintText,
      required this.nomText,
      required this.minLines,
      required this.controller,
      this.validator,
      this.enable,
      this.istexte})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (nomText.isNotEmpty) ...[
            Text(
              nomText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 5),
          ],
          Container(
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // color: const Color(0xffF5F5F5),
            ),
            child: TextFormField(
              enabled: (istexte != null && istexte!) ? true : enable,
              keyboardType: (istexte != null && !istexte!)
                  ? TextInputType.number
                  : TextInputType.text,
              controller: controller,
              minLines: minLines,
              maxLines: minLines,
              validator: validator,
              decoration: InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: hintText,
                fillColor: const Color(0xffF5F5F5),
                filled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
