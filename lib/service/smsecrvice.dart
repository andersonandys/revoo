import 'dart:convert';
import 'package:http/http.dart' as http;

class AfricasTalkingService {
  final String username = "revoos"; // Remplacez par "username" pour production
  final String apiKey =
      "atsk_7ee5fa60dfed2f87fb84868d7768445379976c79b080cdf55002b40b2bdd72ce3b96425d"; // Clé API de votre tableau de bord

  final String endpoint = "https://api.africastalking.com/version1/messaging";

  Future<void> sendSms({
    required String to,
    required String message,
  }) async {
    try {
      // Paramètres de la requête
      final headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'apiKey': apiKey,
      };

      final body = {
        'username': username,
        'to': to,
        'message': message,
      };

      // Envoi de la requête POST
      final response = await http.post(
        Uri.parse(endpoint),
        headers: headers,
        body: body,
      );

      // Vérification de la réponse
      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("Message envoyé avec succès : ${jsonResponse['SMSMessageData']}");
      } else {
        print("Erreur d'envoi : ${response.body}");
      }
    } catch (e) {
      print("Erreur : $e");
    }
  }
}
