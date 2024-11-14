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
      backgroundColor: Colors.greenAccent,
      content: Text(message),
    ));
  }
}
