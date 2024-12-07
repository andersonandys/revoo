import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String idproduit;
  final String accountuid;
  final String nom;
  final String description;
  final int stock;
  final String section;
  final List pointure;
  final List taille;
  final List image;
  final int caract;
  final int prix;
  final String timestamp;
  final int nbrevisite;
  ProductModel(
      {required this.accountuid,
      required this.nom,
      required this.description,
      required this.stock,
      required this.section,
      required this.pointure,
      required this.taille,
      required this.image,
      required this.caract,
      required this.prix,
      required this.timestamp,
      required this.idproduit,
      required this.nbrevisite});
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        accountuid: json['accountuid'] ?? "",
        nom: json['nom'] ?? "",
        description: json['description'] ?? "",
        stock: json['stock'] ?? 0,
        section: json['section'] ?? "",
        pointure: json['pointure'] ?? [],
        taille: json['taille'] ?? [],
        caract: json['caract'] ?? 0,
        prix: json['prix'] ?? 0,
        timestamp: json['timestamp'],
        idproduit: json['idproduit'] ?? "",
        nbrevisite: json['nbrevisite'] ?? 0,
        image: json['image'] ?? []);
  }
  Map<String, dynamic> toJson() => {
        'accountuid': accountuid,
        'prix': prix,
        'idproduit': idproduit,
        'nom': nom,
        'description': description,
        'stock': stock,
        'section': section,
        'pointure': pointure,
        'taille': taille,
        'image': image,
        'nbrevisite': nbrevisite,
        'caract': caract,
        'timestamp': timestamp,
      };
}
