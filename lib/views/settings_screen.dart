import 'dart:io';
import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Expoplace/composant/menu_composant.dart';
import 'package:Expoplace/composant/show_message_composant.dart';
import 'package:Expoplace/controllers/accoun_controller.dart';
import 'package:Expoplace/service/datafirestore_service.dart';
import 'package:Expoplace/views/pricing_screen.dart';
import 'package:Expoplace/views/update_setting/description_update_screen.dart';
import 'package:Expoplace/views/update_setting/name_update_screen.dart';
import 'package:Expoplace/views/update_setting/number_update_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final account = Get.put(AccounController());
  var load = false.obs;
  final _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String expireDate = "";
  @override
  void initState() {
    super.initState();
    // Parse the custom date format from the database

    DateTime now = DateTime.now();
    DateTime nextMonth = DateTime(now.year, now.month, now.day);

    setState(() {
      expireDate = "${nextMonth.day}-${nextMonth.month}-${nextMonth.year}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Paramètre"),
          centerTitle: true,
          leading: const MenuWidget()),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xffF5F5F5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => selectlogo(),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                  account.accountdata.value!.avatar),
                              child: (load.isTrue)
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                account.accountdata.value!.name,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                account.accountdata.value!.lienstore,
                                style: const TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        final qrCode = QrCode.fromData(
                          data:
                              'https://www.google.com/ ${account.accountdata.value!.name} ',
                          errorCorrectLevel: QrErrorCorrectLevel.H,
                        );

                        final qrImage = QrImage(qrCode);
                        final qrImageBytes = await qrImage.toImageAsBytes(
                          size: 512,
                          format: ImageByteFormat.png,
                          decoration: const PrettyQrDecoration(),
                        );
                      },
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: const Color(0xffF5F5F5),
                              borderRadius: BorderRadius.circular(10)),
                          height: 120,
                          width: 120,
                          child: PrettyQrView.data(
                            data:
                                "https://www.google.com/ ${account.accountdata.value!.name} ",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Expanded(
                      child: Text(
                        "Partagez votre code QR avec vos clients pour un accès direct à vos produits, sans besoin d'enregistrer un numéro",
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xffF5F5F5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        (account.accountdata.value!.offre == "")
                            ? "Aucun abonnement actif"
                            : "Plan ${account.accountdata.value!.offre}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Builder(
                        builder: (context) {
                          if (account.accountdata.value!.offre == "") {
                            // Case 1: No active subscription
                            return const Text(
                              "Vous n'avez pas encore souscrit à un abonnement. Profitez de toutes les fonctionnalités en activant un abonnement dès maintenant.",
                              style: TextStyle(fontSize: 17),
                              textAlign: TextAlign.justify,
                            );
                          } else if (expireDate ==
                              account.accountdata.value!.expire) {
                            // Case 2: Subscription expired
                            return const Text(
                              "Votre abonnement a expiré. Veuillez le renouveler pour continuer à profiter des fonctionnalités.",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.redAccent,
                              ),
                              textAlign: TextAlign.justify,
                            );
                          } else if (expireDate !=
                              account.accountdata.value!.expire) {
                            // Case 3: Subscription active
                            return Text(
                              "Vous êtes actuellement sur le plan ${account.accountdata.value!.offre}. Merci pour votre confiance !",
                              style: const TextStyle(fontSize: 17),
                              textAlign: TextAlign.justify,
                            );
                          } else {
                            return const Text(
                              "Impossible de déterminer l'état de votre abonnement. Veuillez contacter le support.",
                              style: TextStyle(
                                  fontSize: 17, color: Colors.redAccent),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 15),
                      if (account.accountdata.value!.offre == "" ||
                          expireDate == account.accountdata.value!.expire)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ActionChip(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const PricingScreen(),
                              ),
                            ),
                            backgroundColor: const Color(0xffFFCF0D),
                            side: const BorderSide(style: BorderStyle.none),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            label: const Text(
                              "Renouveler",
                              style: TextStyle(
                                color: Color(0xff0D3B66),
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const Text(
                  "Réglage du compte",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xffF5F5F5),
                    ),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          onTap: () => Get.bottomSheet(
                              isScrollControlled: true,
                              Wrap(
                                children: [NameUpdateScreen()],
                              )),
                          leading: const CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(0xff0D3B66),
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                          title: const Text(
                            "Nom boutique",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                          subtitle: const Text(
                              "Cette section vous permet de changer le nom de votre boutique."),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                        const Divider(
                          color: Color(0xffD9D9D9),
                          indent: 30,
                          endIndent: 30,
                        ),
                        ListTile(
                          onTap: () => Get.bottomSheet(
                              isScrollControlled: true,
                              Wrap(
                                children: [DescriptionUpdateScreen()],
                              )),
                          leading: const CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(0xff0D3B66),
                            child: Icon(
                              Icons.description,
                              color: Colors.white,
                            ),
                          ),
                          title: const Text(
                            "Description boutique",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                          subtitle: const Text(
                              "Cette section vous permet de mettre à jour la description de votre boutique, qui sera visible par vos clients."),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                        const Divider(
                          color: Color(0xffD9D9D9),
                          indent: 30,
                          endIndent: 30,
                        ),
                        ListTile(
                          onTap: () => selectaffiche(),
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: const Color(0xff0D3B66),
                            child: (load.isTrue)
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.image,
                                    color: Colors.white,
                                  ),
                          ),
                          title: const Text(
                            "Affiche boutique",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                          subtitle: const Text(
                              "Cette section vous permet d'ajouter une affiche à votre boutique, qui sera visible par vos clients."),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                        const Divider(
                          color: Color(0xffD9D9D9),
                          indent: 30,
                          endIndent: 30,
                        ),
                        ListTile(
                          onTap: () => Get.bottomSheet(
                              isScrollControlled: true,
                              Wrap(
                                children: [NumberUpdateScreen()],
                              )),
                          leading: const CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(0xff0D3B66),
                            child: Icon(
                              Icons.numbers,
                              color: Colors.white,
                            ),
                          ),
                          title: const Text(
                            "Numéro WhatsApp",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                          subtitle: const Text(
                              "Cette section vous permet de modifier le numéro WhatsApp de votre boutique."),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                        const Divider(
                          color: Color(0xffD9D9D9),
                          indent: 30,
                          endIndent: 30,
                        ),
                        ListTile(
                          onTap: () => Share.share(
                              'check out my website https://example.com',
                              subject: 'Look what I made!'),
                          leading: const CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(0xff0D3B66),
                            child: Icon(
                              Icons.mobile_screen_share,
                              color: Colors.white,
                            ),
                          ),
                          title: const Text(
                            "Partager ma boutique",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                          subtitle: const Text(
                              "Cette section vous permet de partager votre lien avec vos clients."),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        )
                      ],
                    )),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //  function pour ajouter l affiche dans le design
  Future<void> selectlogo() async {
    final XFile? images = await _picker.pickImage(source: ImageSource.gallery);

    if (images != null) {
      load.value = true;

      load.value = true;

      try {
        // Convertir XFile en File
        File imageFile = File(images.path);

        String fileName =
            'products/${DateTime.now().millisecondsSinceEpoch}_${images.path.split('/').last}';
        UploadTask uploadTask =
            _storage.ref().child(fileName).putFile(imageFile);

        TaskSnapshot snapshot = await uploadTask;
        String lien = await snapshot.ref.getDownloadURL();

        // Mise à jour de Firestore avec le lien de l'image
        DatafirestoreService.data_firestore_account
            .doc(account.accountdata.value!.accountuid)
            .update({"avatar": lien});

        ShowMessageComposant.messagesucces(
            context, "Votre logo a été ajouté avec succès.");
      } catch (e) {
        ShowMessageComposant.message(
            context, "Erreur lors du téléchargement de l'image");
        throw e;
      } finally {
        load.value = false;
      }
    } else {
      load.value = false;
      ShowMessageComposant.message(
          context, "Vous devez sélectionner au moins, une image.");
    }
  }

  //  function pour ajouter une affiche
  Future<void> selectaffiche() async {
    final XFile? images = await _picker.pickImage(source: ImageSource.gallery);

    if (images != null) {
      load.value = true;

      load.value = true;

      try {
        // Convertir XFile en File
        File imageFile = File(images.path);

        String fileName =
            'products/${DateTime.now().millisecondsSinceEpoch}_${images.path.split('/').last}';
        UploadTask uploadTask =
            _storage.ref().child(fileName).putFile(imageFile);

        TaskSnapshot snapshot = await uploadTask;
        String lien = await snapshot.ref.getDownloadURL();

        // Mise à jour de Firestore avec le lien de l'image
        DatafirestoreService.data_firestore_account
            .doc(account.accountdata.value!.accountuid)
            .update({"affiche": lien});

        ShowMessageComposant.messagesucces(
            context, "Votre affiche a été ajouté avec succès.");
      } catch (e) {
        ShowMessageComposant.message(
            context, "Erreur lors du téléchargement de l'image");
        throw e;
      } finally {
        load.value = false;
      }
    } else {
      load.value = false;
      ShowMessageComposant.message(
          context, "Vous devez sélectionner au moins, une image.");
    }
  }
}
