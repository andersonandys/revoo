import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Expoplace/composant/input_composant.dart';
import 'package:Expoplace/composant/menu_composant.dart';
import 'package:Expoplace/composant/show_message_composant.dart';
import 'package:Expoplace/controllers/accoun_controller.dart';
import 'package:Expoplace/models/product_model.dart';
import 'package:Expoplace/service/datafirestore_service.dart';
import 'package:uuid/uuid.dart';

class ProductUpdateScreen extends StatefulWidget {
  const ProductUpdateScreen({Key? key}) : super(key: key);

  @override
  _ProductUpdateScreenState createState() => _ProductUpdateScreenState();
}

class _ProductUpdateScreenState extends State<ProductUpdateScreen> {
  final nomproduc = TextEditingController();
  final description = TextEditingController();
  final stock = TextEditingController();
  final pointurecontroller = TextEditingController();
  final prix = TextEditingController();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<Map<String, String>> caraacteristique = [
    {"nom": "Aucun"},
    {"nom": "Taille"},
    {"nom": "Pointure"}
  ];
  List<Map<String, String>> taille = [
    {"nom": "X"},
    {"nom": "XL"},
    {"nom": "L"},
    {"nom": "M"},
    {"nom": "S"}
  ];
  final RxList<String> pointures = <String>[].obs;
  var selectedIndex = 5.obs;
  final RxList<String> selecttaille = <String>[].obs;
  var selectsection = "".obs;
  final _key = GlobalKey<FormState>();
  final key1 = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImages = [];
  RxInt uploadProgress = 0.obs;
  RxInt totalImages = 0.obs;
  var load = false.obs;
  final accountuid = FirebaseAuth.instance.currentUser!.uid;
  final product = Get.put(AccounController());
  List<String> _selectedImagesUrls = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modification du produit"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Obx(
            () => Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: <Widget>[
                      // Bouton "Ajouter" pour sélectionner les images
                      GestureDetector(
                        onTap: _pickImages,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xffF5F5F5),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: const Color(0xffFFCF0D),
                                radius: 25,
                                child: (load.isTrue)
                                    ? const CircularProgressIndicator(
                                        color: Color(0xff0D3B66),
                                      )
                                    : const Icon(
                                        Icons.add,
                                        size: 40,
                                        color: Color(0xff0D3B66),
                                      ),
                              ),
                              const SizedBox(height: 5),
                              (load.isTrue)
                                  ? const Text("")
                                  : const Text("Ajouter")
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Espace pour afficher les images sélectionnées
                      Expanded(
                        child: SizedBox(
                          height: 100,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                product.updateproduct.value!.image.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(2),
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xffF5F5F5),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        product
                                            .updateproduct.value!.image[index],
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                          Icons.image_not_supported,
                                          color: Colors.grey,
                                        ),
                                        loadingBuilder:
                                            (context, child, loadingProgress) =>
                                                child,
                                      ),
                                    ),
                                  ),
                                  // Icône de suppression
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: GestureDetector(
                                      onTap: () => _removeOldImage(index),
                                      child: const CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Colors.redAccent,
                                        child: Icon(
                                          Icons.close,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  InputComposant(
                    hintText: product.updateproduct.value!.nom,
                    nomText: 'Nom',
                    minLines: 1,
                    controller: nomproduc,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le nom du produit';
                      }
                      return null;
                    },
                  ),
                  InputComposant(
                    hintText: product.updateproduct.value!.description,
                    nomText: 'Description',
                    minLines: 3,
                    controller: description,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer la description du produit';
                      }
                      return null;
                    },
                  ),
                  InputComposant(
                    hintText: product.updateproduct.value!.prix.toString(),
                    nomText: 'Prix',
                    minLines: 1,
                    istexte: false,
                    controller: prix,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le prix du produit';
                      }
                      return null;
                    },
                  ),
                  InputComposant(
                    hintText: product.updateproduct.value!.stock.toString(),
                    nomText: 'Stock',
                    minLines: 1,
                    istexte: false,
                    controller: stock,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le nombre de stock du produit';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        "Section",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      ActionChip(
                          onPressed: () => Get.bottomSheet(
                              isScrollControlled: true,
                              Wrap(
                                children: [addsection()],
                              )),
                          side: const BorderSide(style: BorderStyle.none),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          backgroundColor: const Color(0xffFFE066),
                          label: const Text("Ajouter"))
                    ],
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder(
                    stream: DatafirestoreService.data_firestore_account
                        .doc(accountuid)
                        .collection('section')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return (snapshot.data!.docs.isEmpty)
                          ? const Text(
                              "Vous n'avez pas de section, Vous devez en ajouter",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          : SizedBox(
                              height: 50,
                              child: ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  var section = snapshot.data!.docs[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Obx(
                                      () => ActionChip(
                                          onPressed: () {
                                            DatafirestoreService
                                                .data_firestore_product
                                                .doc(product.updateproduct
                                                    .value!.idproduit)
                                                .update({
                                              "section": section['nom']
                                            });
                                          },
                                          side: BorderSide(
                                            style: BorderStyle.solid,
                                            color: (product.updateproduct.value!
                                                        .section ==
                                                    section['nom'])
                                                ? const Color(0xff0D3B66)
                                                : Colors.black,
                                          ),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                          backgroundColor: (product
                                                      .updateproduct
                                                      .value!
                                                      .section ==
                                                  section['nom'])
                                              ? const Color(0xff0D3B66)
                                              : Colors.white,
                                          label: Text(
                                            section['nom']!,
                                            style: TextStyle(
                                                color: (product.updateproduct
                                                            .value!.section ==
                                                        section['nom'])
                                                    ? Colors.white
                                                    : Colors.black),
                                          )),
                                    ),
                                  );
                                },
                              ),
                            );
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Caracteristique",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: SizedBox(
                      height: 50,
                      child: ListView.builder(
                        itemCount: caraacteristique.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ActionChip(
                                onPressed: () {
                                  ShowMessageComposant.message(context,
                                      "Vous ne pouvez pas changer la caracteristique");
                                },
                                side: BorderSide(
                                    style: BorderStyle.solid,
                                    color:
                                        (product.updateproduct.value!.caract ==
                                                index)
                                            ? const Color(0xff0D3B66)
                                            : Colors.black),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                backgroundColor:
                                    (product.updateproduct.value!.caract ==
                                            index)
                                        ? const Color(0xff0D3B66)
                                        : Colors.white,
                                label: Text(
                                  caraacteristique[index]['nom']!,
                                  style: TextStyle(
                                      color: (product.updateproduct.value!
                                                  .caract ==
                                              index)
                                          ? Colors.white
                                          : Colors.black),
                                )),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (product.updateproduct.value!.caract == 1)
                    Showtaille(context),
                  if (product.updateproduct.value!.caract == 2)
                    ShowPointure(
                        context, product.updateproduct.value!.pointure),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() => (totalImages.value != 0)
                      ? Column(
                          children: [
                            Text(
                              "Téléchargement des images : ${uploadProgress.value}/${totalImages.value}",
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 10),
                            LinearProgressIndicator(
                              value: (totalImages.value == 0)
                                  ? 0
                                  : uploadProgress.value / totalImages.value,
                            ),
                          ],
                        )
                      : const SizedBox()),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () => sendPublication(),
                      child: (load.value)
                          ? const CircularProgressIndicator()
                          : const Text("Modifier le produit"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// widget pour afficher la taile du produit

  Widget Showtaille(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text(
              "Veuillez sélectionner les tailles disponibles pour votre vêtement. Cela garantit une meilleure expérience d'achat et une sélection précise lors de la commande."),
          const SizedBox(height: 10),
          SizedBox(
            height: 70,
            child: ListView.builder(
              itemCount: taille.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                final String tailleNom = taille[index]['nom']!;
                return Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () {
                        // Ajouter ou retirer la taille sélectionnée
                        if (product.updateproduct.value!.taille
                            .contains(tailleNom)) {
                          List data = product.updateproduct.value!.taille;
                          data.remove(tailleNom);
                          DatafirestoreService.data_firestore_product
                              .doc(product.updateproduct.value!.idproduit)
                              .update({'taille': data});
                          print(data);
                        } else {
                          List data = product.updateproduct.value!.taille;
                          data.add(tailleNom);
                          DatafirestoreService.data_firestore_product
                              .doc(product.updateproduct.value!.idproduit)
                              .update({'taille': data});
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: product.updateproduct.value!.taille
                                .contains(tailleNom)
                            ? const Color(
                                0xff0D3B66) // Couleur si récupérée de Firestore
                            : (selecttaille.contains(tailleNom)
                                ? const Color(
                                    0xff0D3B66) // Couleur si sélectionnée
                                : const Color(
                                    0xffF5F5F5)), // Couleur non sélectionnée
                        radius: 25,
                        child: Text(
                          tailleNom,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: product.updateproduct.value!.taille
                                        .contains(tailleNom) ||
                                    selecttaille.contains(tailleNom)
                                ? Colors
                                    .white // Texte blanc si sélectionné ou récupéré
                                : Colors.black, // Texte noir si non sélectionné
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // widget pour afficher la poiture

  Widget ShowPointure(BuildContext context, oldpointure) {
    return Center(
      child: Form(
        key: key1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                "Veuillez ajouter les pointures disponibles pour votre chaussure. Cela garantit une meilleure expérience d'achat et une sélection précise lors de la commande."),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: InputComposant(
                    hintText: "Pointure de la chaussure",
                    nomText: 'Pointure',
                    minLines: 1,
                    istexte: false,
                    controller: pointurecontroller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer la pointure de la chaussure';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color(0xffFFCF0D),
                  ),
                  child: Center(
                    child: IconButton(
                      icon: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                      onPressed: () {
                        // Valider le formulaire et ajouter la pointure à la liste
                        if (key1.currentState!.validate()) {
                          String pointure = pointurecontroller.text.trim();
                          if (!pointures.contains(pointure) &&
                              !oldpointure.contains(pointure)) {
                            pointures.add(pointure);
                            pointurecontroller.clear();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Pointure déjà ajoutée")),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              "Pointures ajoutées :",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Obx(
              () => (pointures.isEmpty && oldpointure.isEmpty)
                  ? const Text("Aucune pointure ajoutée pour le moment")
                  : Wrap(
                      spacing: 10,
                      children: [
                        ...oldpointure.map((pointure) =>
                            buildChip(pointure, context, isOld: true)),
                        ...pointures
                            .map((pointure) => buildChip(pointure, context)),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

// Fonction pour créer un widget Chip avec un bouton de suppression
  Widget buildChip(String pointure, BuildContext context,
      {bool isOld = false, oldpointure}) {
    return Chip(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      side: BorderSide.none,
      backgroundColor: const Color(0xff0D3B66),
      avatar: const Icon(
        Icons.check,
        size: 20,
        color: Colors.white,
      ),
      label: Text(
        pointure,
        style: const TextStyle(color: Colors.white),
      ),
      deleteIcon: const Icon(
        Icons.close,
        color: Colors.redAccent,
      ),
      onDeleted: () async {
        if (isOld && product.updateproduct.value!.pointure.isNotEmpty) {
          // Supprimer de Firestore
          List newpointure = product.updateproduct.value!.pointure;
          newpointure.remove(pointure);
          try {
            await DatafirestoreService.data_firestore_product
                .doc(product.updateproduct.value!.idproduit)
                .update({'pointure': newpointure});
          } catch (e) {
            ShowMessageComposant.message(
                context, "Erreur lors de la mise à jour");
          }
        } else {
          pointures.remove(pointure);
        }
      },
    );
  }

  // publication du produit
  sendPublication() {
    DatafirestoreService.data_firestore_product
        .doc(product.updateproduct.value!.idproduit)
        .update({
      "nom": (nomproduc.text.isEmpty)
          ? product.updateproduct.value!.nom
          : nomproduc.text,
      "description": (description.text.isEmpty)
          ? product.updateproduct.value!.description
          : description.text,
      "prix": (prix.text.isEmpty)
          ? product.updateproduct.value!.prix
          : int.parse(prix.text),
      "stock": (stock.text.isEmpty)
          ? product.updateproduct.value!.stock
          : int.parse(stock.text),
    });
    if (nomproduc.text.isEmpty ||
        description.text.isEmpty ||
        prix.text.isEmpty ||
        stock.text.isEmpty) {
      ShowMessageComposant.messagesucces(
          context, "Votre modification a été prise en compte.");
    }
  }

// Fonction pour uploader une image et obtenir le lien de téléchargement
  Future<String> uploadImage(File imageFile) async {
    try {
      String fileName =
          'products/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      UploadTask uploadTask = _storage.ref().child(fileName).putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      load.value = false;
      throw e;
    }
  }

// Méthode pour sélectionner plusieurs images
  Future<void> _pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();

    if (images != null && images.isNotEmpty) {
      load.value = true;
      _selectedImages
          .addAll(images); // Ajouter les images sélectionnées à la liste

      // Uploader les images et récupérer les URLs
      await _uploadImages();
    } else {
      load.value = false;
      ShowMessageComposant.message(
          context, "Vous devez sélectionner au moins, une image.");
    }
  }

// Méthode pour uploader les images et obtenir les URLs
  Future<void> _uploadImages() async {
    for (XFile image in _selectedImages) {
      // Convertir XFile en File
      final file = File(image.path);

      // Créer un nom de fichier unique
      String fileName =
          'products/${DateTime.now().millisecondsSinceEpoch}_${image.name}';

      try {
        // Uploader l'image dans Firebase Storage
        UploadTask uploadTask =
            FirebaseStorage.instance.ref().child(fileName).putFile(file);
        TaskSnapshot snapshot = await uploadTask;

        // Obtenir l'URL de téléchargement
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Ajouter l'URL de l'image téléchargée à la liste
        _selectedImagesUrls.add(downloadUrl);
      } catch (e) {
        load.value = false;
        ShowMessageComposant.message(
            context, "Erreur lors du téléchargement de l'image");
      }
    }

    // Mettre à jour Firestore avec les nouvelles URLs
    await _updateFirestoreImages();
  }

// Méthode pour mettre à jour Firestore avec les URLs complètes des images
  Future<void> _updateFirestoreImages() async {
    // Obtenir les anciennes images de Firestore
    DocumentSnapshot snapshot = await DatafirestoreService
        .data_firestore_product
        .doc(product
            .updateproduct.value!.idproduit) // Remplace par l'ID de ton produit
        .get();

    List<String> existingImages =
        List<String>.from(snapshot.get('image') ?? []);

    // Ajouter les nouvelles images aux anciennes
    List<String> updatedImages = [...existingImages, ..._selectedImagesUrls];

    // Mettre à jour Firestore avec la liste combinée des images
    await DatafirestoreService.data_firestore_product
        .doc(product
            .updateproduct.value!.idproduit) // Remplace par l'ID de ton produit
        .update({'image': updatedImages});

    ShowMessageComposant.messagesucces(
        context, "Images mises à jour avec succès!");
    // Réinitialiser les images sélectionnées pour une future sélection
    _selectedImages.clear();
    _selectedImagesUrls.clear();
  }

  void _removeOldImage(int index) async {
    // Création d'une nouvelle liste d'images pour mise à jour
    List<String> updatedImages = List.from(product.updateproduct.value!.image);
    updatedImages.removeAt(index);

    // Mise à jour de Firestore si besoin
    try {
      await DatafirestoreService.data_firestore_product
          .doc(product.updateproduct.value!.idproduit) // ID du produit
          .update({'image': updatedImages});
      ShowMessageComposant.messagesucces(
          context, "Image supprimée avec succès !");
    } catch (e) {
      ShowMessageComposant.messagesucces(
          context, "Erreur lors de la suppression de l'image !");
    }
  }
}

class addsection extends StatefulWidget {
  addsection({Key? key}) : super(key: key);

  @override
  State<addsection> createState() => _addsectionState();
}

class _addsectionState extends State<addsection> {
  final nomsection = TextEditingController();

  final accountuid = FirebaseAuth.instance.currentUser!.uid;

  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      padding: const EdgeInsets.all(10),
      child: Form(
        key: key,
        child: Column(
          children: <Widget>[
            Container(
              height: 5,
              width: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.black),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
                "Ajoutez des sections à votre catalogue \n Organisez vos produits en catégories claires, comme Chaussures, Montres ou Vêtements, pour aider vos clients à trouver rapidement ce qu'ils recherchent. Une bonne organisation améliore leur expérience d'achat et augmente vos ventes."),
            const SizedBox(
              height: 10,
            ),
            InputComposant(
              hintText: "section de vos produit",
              nomText: 'Section',
              minLines: 1,
              controller: nomsection,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Veuillez saisir le nom d'une section.";
                }
                return null;
              },
            ),
            ElevatedButton(
                onPressed: () {
                  if (key.currentState!.validate()) {
                    DatafirestoreService.data_firestore_account
                        .doc(accountuid)
                        .collection("section")
                        .add({"nom": nomsection.text});
                    ShowMessageComposant.messagesucces(
                        context, "Section ajoutée avec succès.");
                  }
                  Navigator.pop(context);
                },
                child: const Text("Modifier le produit"))
          ],
        ),
      ),
    );
  }
}
