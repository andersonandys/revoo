// models/user_stats.dart

class AccountstatModel {
  final int produit;
  final int requette;
  final int visit;
  final int vente;

  AccountstatModel(
      {required this.produit,
      required this.requette,
      required this.visit,
      required this.vente});

  // Crée une instance de AccountstatModel à partir d'une map Firestore
  factory AccountstatModel.fromJson(Map<String, dynamic> json) =>
      AccountstatModel(
        produit: json['produit'] ?? 0,
        requette: json['requette'] ?? 0,
        visit: json['visit'] ?? 0,
        vente: json['vente'] ?? 0,
      );

  // Convertit AccountstatModel en map pour sauvegarde dans Firestore
  Map<String, dynamic> toJson() => {
        'produit': produit,
        'requette': requette,
        'visit': visit,
        'vente': vente,
      };
}
