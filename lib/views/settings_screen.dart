import 'dart:io';
import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:revoo/composant/menu_composant.dart';
import 'package:revoo/composant/show_message_composant.dart';
import 'package:revoo/controllers/accoun_controller.dart';
import 'package:revoo/service/datafirestore_service.dart';
import 'package:revoo/views/update_setting/name_update_screen.dart';
import 'package:revoo/views/update_setting/number_update_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Paramettre"),
          centerTitle: true,
          leading: const MenuWidget()),
      body: Padding(
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
                        Obx(
                          () => GestureDetector(
                            onTap: () => selectaffiche(),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.white,
                              child: (load.isTrue)
                                  ? CircularProgressIndicator()
                                  : null,
                              backgroundImage: NetworkImage(
                                  account.accountdata.value!.avatar),
                            ),
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
                              account.accountdata.value!.number,
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
              GestureDetector(
                onTap: () async {
                  final qrCode = QrCode.fromData(
                    data: 'lorem ipsum dolor sit amet',
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
                    color: const Color(0xffF5F5F5),
                    height: 200,
                    width: 200,
                    child: PrettyQrView.data(
                      data:
                          "https://www.google.com/ ${account.accountdata.value!.name} ",
                      decoration: PrettyQrDecoration(
                        image: PrettyQrDecorationImage(
                          filterQuality: FilterQuality.high,
                          image:
                              NetworkImage(account.accountdata.value!.avatar),
                        ),
                      ),
                    ),
                  ),
                ),
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
                    const Text(
                      "Plan gratuit",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Lorem Ipsum is simply dummy text of the printing an dummy text of the",
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ActionChip(
                          onPressed: () {},
                          backgroundColor: const Color(0xffFFCF0D),
                          side: const BorderSide(style: BorderStyle.none),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          label: const Text(
                            "Changer",
                            style: TextStyle(color: Color(0xff0D3B66)),
                          )),
                    )
                  ],
                ),
              ),
              const Text(
                "Reglage du compte",
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
                        onTap: () {},
                        leading: const CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xff0D3B66),
                          child: Icon(
                            Iconsax.mobile,
                            color: Colors.white,
                          ),
                        ),
                        title: const Text(
                          "Apparende de la boutique",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        subtitle: const Text(
                            "Cette fonctionnalite vous permet de visualiser le rendu de votre application"),
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
                            "Cette fonction vous permet de modifer le nom de votre boutique"),
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
                          "Numero whatsapp",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        subtitle: const Text(
                            "Cette fonction vous permet de modifer le numero whatsapp de votre boutique"),
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
                            "Cette fonctionnalite vous permet de partager votre lien a vos amie"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      )
                    ],
                  )),
              const SizedBox(
                height: 10,
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
                        onTap: () {},
                        leading: const CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xffFFE066),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        title: const Text(
                          "Déconnexion",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  //  function pour ajouter l affiche dans le design
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
            .update({"avatar": lien});

        ShowMessageComposant.messagesucces(
            context, "Votre affiche a été ajoutée avec succès");
      } catch (e) {
        ShowMessageComposant.message(
            context, "Erreur lors de l'upload de l'image");
        throw e;
      } finally {
        load.value = false;
      }
    } else {
      load.value = false;
      ShowMessageComposant.message(
          context, "Vous devez selectionner au moins une image");
    }
  }
}
