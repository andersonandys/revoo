import 'dart:io';

import 'package:Expoplace/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

class AddproductScreen extends StatefulWidget {
  const AddproductScreen({Key? key}) : super(key: key);

  @override
  _AddproductScreenState createState() => _AddproductScreenState();
}

class _AddproductScreenState extends State<AddproductScreen> {
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

  final accountdata = Get.put(AccounController());
  String expireDate = "";
  @override
  void initState() {
    super.initState();

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
        title: const Text("Ajout de produit"),
        centerTitle: true,
        leading: const MenuWidget(),
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
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Color(0xffFFCF0D),
                                radius: 25,
                                child: Icon(
                                  Icons.add,
                                  size: 40,
                                  color: Color(0xff0D3B66),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text("Ajouter")
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
                            itemCount: _selectedImages.length,
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
                                      child: Image.file(
                                        File(_selectedImages[index].path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // Icône de suppression
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: GestureDetector(
                                      onTap: () => _removeImage(index),
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
                    hintText: "Nom du produit",
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
                    hintText: "Description du produit",
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
                    hintText: "Prix du produit",
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
                    hintText: "Stock du produit",
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
                        .doc(globalUid)
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
                                            selectsection.value =
                                                section['nom']!;
                                          },
                                          side: BorderSide(
                                            style: BorderStyle.solid,
                                            color: (selectsection.value ==
                                                    section['nom'])
                                                ? const Color(0xff0D3B66)
                                                : Colors.black,
                                          ),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                          backgroundColor:
                                              (selectsection.value ==
                                                      section['nom'])
                                                  ? const Color(0xff0D3B66)
                                                  : Colors.white,
                                          label: Text(
                                            section['nom']!,
                                            style: TextStyle(
                                                color: (selectsection.value ==
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
                    "Caractéristique",
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
                                  selectedIndex.value = index;
                                },
                                side: BorderSide(
                                    style: BorderStyle.solid,
                                    color: (selectedIndex.value == index)
                                        ? const Color(0xff0D3B66)
                                        : Colors.black),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                backgroundColor: (selectedIndex.value == index)
                                    ? const Color(0xff0D3B66)
                                    : Colors.white,
                                label: Text(
                                  caraacteristique[index]['nom']!,
                                  style: TextStyle(
                                      color: (selectedIndex.value == index)
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
                  if (selectedIndex.value == 1) Showtaille(context),
                  if (selectedIndex.value == 2) ShowPointure(context),
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
                  if (accountdata.accountdata.value!.expire.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Effectuer votre premier abonnement pour avoir accès à cette fonction ",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                    )
                  else ...[
                    if (accountdata.accountdata.value!.expire == expireDate)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Votre abonnement a expiré, vous devez vous réabonner pour avoir accès à cette fonction.",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      )
                    else ...[
                      if (accountdata.accountdata.value!.offre == 'basic' &&
                          accountdata.accountdata.value!.nbreproduit == 10)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Vous avez atteint le nombre de produits autorisé. ",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.justify,
                          ),
                        )
                      else
                        ElevatedButton(
                            onPressed: () => sendPublication(),
                            child: (load.value)
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text("Publier le produit"))
                    ]
                  ],
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
                        if (selecttaille.contains(tailleNom)) {
                          selecttaille.remove(tailleNom);
                        } else {
                          selecttaille.add(tailleNom);
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: selecttaille.contains(tailleNom)
                            ? const Color(0xff0D3B66) // Couleur sélectionnée
                            : const Color(
                                0xffF5F5F5), // Couleur non sélectionnée
                        radius: 25,
                        child: Text(
                          tailleNom,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: selecttaille.contains(tailleNom)
                                ? Colors.white // Texte blanc si sélectionné
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
  Widget ShowPointure(BuildContext context) {
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
                          if (!pointures.contains(pointure)) {
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
              () => pointures.isEmpty
                  ? const Text("Aucune pointure ajoutée pour le moment")
                  : Wrap(
                      spacing: 10,
                      children: pointures.map((pointure) {
                        return Chip(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          side: BorderSide.none,
                          backgroundColor: const Color(0xff0D3B66),
                          avatar: const Iconify(
                            Mdi.shoe_print,
                            size: 30,
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
                          onDeleted: () {
                            pointures.remove(pointure);
                          },
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // publication du produit
  sendPublication() {
    if (_selectedImages.isEmpty) {
      ShowMessageComposant.message(
          context, "Vous devez sélectionner au moins, une image.");
    } else if (_key.currentState!.validate()) {
      if (selectsection.value.isEmpty) {
        ShowMessageComposant.message(
            context, "Vous devez sélectionner une section.");
      } else {
        switch (selectedIndex.value) {
          case 0:
            sendData(); // Appel de sendData avec les URLs d'images
            break;
          case 1:
            if (selecttaille.isEmpty) {
              ShowMessageComposant.message(
                  context, "Vous devez sélectionner au moins, une taille.");
            } else {
              sendData();
            }
            break;
          case 2:
            if (pointures.isEmpty) {
              ShowMessageComposant.message(
                  context, "Vous devez ajouter au moins une pointure.");
            } else {
              sendData();
            }
            break;
          default:
            ShowMessageComposant.message(
                context, "Vous devez choisir une caractéristique.");
            break;
        }
      }
    }
  }

  // Fonction pour uploader une image et obtenir le lien
// Fonction pour uploader une image et obtenir le lien de téléchargement
// Fonction pour envoyer les données dans Firestore avec les liens d’images
  Future<void> sendData() async {
    final DateTime now = DateTime.now();
    final String month =
        now.month.toString().padLeft(2, '0'); // Format '01', '02', etc.
    var uuid = const Uuid();
    load.value = true;
    List<String> imageUrls = [];
    String idproduit = uuid.v1();
    totalImages.value = _selectedImages.length;
    // Boucle pour uploader chaque image et obtenir les liens
    for (var image in _selectedImages) {
      try {
        // Convertir XFile en File
        File fileImage = File(image.path);
        String downloadUrl = await uploadImage(fileImage);
        imageUrls.add(downloadUrl);
        uploadProgress.value += 1; // Mise à jour de la progression
      } catch (e) {
        ShowMessageComposant.message(
            context, "Erreur pendant le téléchargement de l'image ");
      }
    }
    // Vérifier si tous les téléchargements d’images sont terminés
    if (imageUrls.length == _selectedImages.length) {
      DatafirestoreService.data_firestore_product.doc(idproduit).set(
            ProductModel(
              accountuid: globalUid!,
              nom: nomproduc.text,
              description: description.text,
              stock: stock.text.isEmpty ? 0 : int.parse(stock.text),
              section: selectsection.value,
              pointure: pointures.toList(),
              taille: selecttaille.toList(),
              image: imageUrls,
              prix: int.parse(prix.text),
              caract: selectedIndex.value,
              idproduit: idproduit,
              nbrevisite: 0,
              timestamp: DateTime.now().toString(),
            ).toJson(),
          );
      DatafirestoreService.data_firestore_account
          .doc(globalUid)
          .update({"nbreproduit": FieldValue.increment(1)});
      DatafirestoreService.data_firestore_account
          .doc(
              globalUid) // Remplace 'userId' par l'ID de l'utilisateur connecté si nécessaire
          .collection('stats')
          .doc(month)
          .update({"produit": FieldValue.increment(1)});

      ShowMessageComposant.messagesucces(
          context, "Votre produit a été publié avec succès.");
      load.value = false;
      uploadProgress.value = 0;
      totalImages.value = 0;
      selectedIndex.value = 5;
      selectsection.value = "";
      prix.clear();
      selecttaille.clear();
      stock.clear();
      description.clear();
      nomproduc.clear();
      pointurecontroller.clear();
      _selectedImages.clear();
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
    final List<XFile>? images = await _picker
        .pickMultiImage(); // Utiliser pickMultiImage pour plusieurs images

    if (images != null) {
      setState(() {
        _selectedImages
            .addAll(images); // Ajouter les images sélectionnées à la liste
      });
    }
  }

  // Méthode pour supprimer une image
  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }
}

class addsection extends StatefulWidget {
  addsection({Key? key}) : super(key: key);

  @override
  State<addsection> createState() => _addsectionState();
}

class _addsectionState extends State<addsection> {
  final nomsection = TextEditingController();

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
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  if (key.currentState!.validate()) {
                    DatafirestoreService.data_firestore_account
                        .doc(globalUid)
                        .collection("section")
                        .add({"nom": nomsection.text});
                    ShowMessageComposant.messagesucces(
                        context, "Section ajoute avec succes");
                  }
                  Navigator.pop(context);
                },
                child: const Text("Ajouter la section"))
          ],
        ),
      ),
    );
  }
}
