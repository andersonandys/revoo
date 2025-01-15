import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class InputComposant extends StatefulWidget {
  final String hintText;
  final String nomText;
  final int minLines;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool? enable;
  final bool? istexte;
  bool? obscureText;
  final Function()? onEditingCompletes;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  InputComposant(
      {Key? key,
      required this.hintText,
      required this.nomText,
      required this.minLines,
      required this.controller,
      this.validator,
      this.enable,
      this.istexte,
      this.obscureText,
      this.onEditingCompletes,
      this.onFieldSubmitted,
      this.onChanged})
      : super(key: key);

  @override
  State<InputComposant> createState() => _InputComposantState();
}

class _InputComposantState extends State<InputComposant> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.nomText.isNotEmpty) ...[
            Text(
              widget.nomText,
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
              enabled: (widget.enable != null && widget.enable!)
                  ? true
                  : widget.enable,
              keyboardType: (widget.istexte == null || widget.istexte == true)
                  ? TextInputType.text
                  : TextInputType.number,
              obscureText: (widget.obscureText != null && widget.obscureText!)
                  ? true
                  : false,
              controller: widget.controller,
              minLines: widget.minLines,
              maxLines: widget.minLines,
              validator: widget.validator,
              onEditingComplete: widget.onEditingCompletes,
              onFieldSubmitted: widget.onFieldSubmitted,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: widget.hintText,
                  fillColor: const Color(0xffF5F5F5),
                  filled: true,
                  suffixIcon: (widget.obscureText != null)
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              widget.obscureText = !widget.obscureText!;
                            });
                          },
                          icon: (widget.obscureText!)
                              ? const Icon(Iconsax.eye)
                              : const Icon(Iconsax.eye_slash))
                      : null),
            ),
          ),
        ],
      ),
    );
  }
}
