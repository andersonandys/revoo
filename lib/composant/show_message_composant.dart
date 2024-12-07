import 'package:flutter/material.dart';

class ShowMessageComposant {
  static message(context, message) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text(message),
    ));
  }

  static messagesucces(context, message) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: const Color.fromARGB(255, 2, 117, 61),
      content: Text(message),
    ));
  }
}
