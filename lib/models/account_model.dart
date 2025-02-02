class AccountModel {
  final String name;
  final String description;
  final String typeEmplacementShop;
  final String number;
  final String avatar;
  final String localisation;
  final String lienstore;
  final String position;
  final String accountuid;
  final String offre;
  final int nbreproduit;
  final int nbrereque;
  final int nbrevente;
  final int nbrevisite;
  final String affiche;
  final String expire;
  final String mdp;
  final String colorfavoris;

  AccountModel({
    required this.name,
    required this.description,
    required this.typeEmplacementShop,
    required this.number,
    required this.localisation,
    required this.lienstore,
    required this.position,
    required this.avatar,
    required this.accountuid,
    required this.offre,
    required this.nbreproduit,
    required this.affiche,
    required this.nbrereque,
    required this.nbrevente,
    required this.nbrevisite,
    required this.expire,
    required this.mdp,
    required this.colorfavoris,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
        name: json["name"] ?? "",
        description: json["description"] ?? "",
        typeEmplacementShop: json["typeEmplacementShop"] ?? "",
        number: json["number"] ?? "",
        avatar: json["avatar"] ?? "",
        localisation: json["localisation"] ?? "",
        lienstore: json["lienstore"] ?? "",
        position: json["position"] ?? "",
        accountuid: json["accountuid"] ?? "",
        affiche: json["affiche"] ?? "",
        nbreproduit: json["nbreproduit"] ?? 0,
        nbrereque: json["nbrereque"] ?? 0,
        nbrevente: json["nbrevente"] ?? 0,
        nbrevisite: json["nbrevisite"] ?? 0,
        offre: json["offre"] ?? "",
        expire: json["expire"] ?? "",
        colorfavoris: json["colorfavoris"] ?? "",
        mdp: json["mdp"] ?? "",
      );
  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "typeEmplacementShop": typeEmplacementShop,
        "number": number,
        "avatar": avatar,
        "affiche": affiche,
        "localisation": localisation,
        "lienstore": lienstore,
        "position": position,
        "accountuid": accountuid,
        "offre": offre,
        "nbreproduit": nbreproduit,
        "nbrereque": nbrereque,
        "nbrevente": nbrevente,
        "nbrevisite": nbrevisite,
        "expire": expire,
        "mdp": mdp,
        "colorfavoris": colorfavoris,
      };
}
