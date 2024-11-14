import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:revoo/composant/menu_composant.dart';
import 'package:revoo/composant/show_message_composant.dart';
import 'package:revoo/controllers/accoun_controller.dart';
import 'package:revoo/models/product_model.dart';
import 'package:revoo/service/datafirestore_service.dart';
import 'package:revoo/views/chart/global_chart_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final account = Get.put(AccounController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          account.accountdata.value!.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: const MenuWidget(),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: GestureDetector(
              child: const CircleAvatar(
                backgroundColor: Color(0xffFFCF0D),
                child: Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    carddata(
                        const Color(0xffC4FCEF),
                        "Produit",
                        account.accountdata.value!.nbreproduit,
                        const Icon(
                          Iconsax.box,
                          size: 30,
                        )),
                    carddata(
                        const Color(0xffFEFEDF),
                        "Demande",
                        account.accountdata.value!.nbrereque,
                        const Icon(
                          Iconsax.send_1,
                          size: 30,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    carddata(
                        const Color(0xffFCF7FF),
                        "Viste",
                        account.accountdata.value!.nbrevisite,
                        const Icon(
                          Iconsax.eye,
                          size: 30,
                        )),
                    carddata(
                        const Color(0xffDEF4FE),
                        "Vente",
                        account.accountdata.value!.nbrevente,
                        const Icon(
                          Iconsax.bag,
                          size: 30,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                if (account.accountdata.value!.nbreproduit == 0 ||
                    account.accountdata.value!.affiche == "") ...[
                  Center(
                    child: Text(
                      "Bienvue, ${account.accountdata.value!.name}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Pour utiliser votre boutique a son plein  potentiel nous allons vous donner quelque recommentationa suivre",
                    style: TextStyle(fontSize: 17),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Tache a effectuer",
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 10,
                  ),
                ],
                if (account.accountdata.value!.nbreproduit == 0) ...[
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xffF5F5F5)),
                    child: const ListTile(
                      title: Text("Publier un produit"),
                      subtitle: Text(
                          "Rendez-vous dans le menu et cliqer sur 'ajouter un article' et remplissez le formulaire pour la soumission"),
                      trailing: CircleAvatar(
                        child: Icon(Icons.clear),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
                if (account.accountdata.value!.affiche == "") ...[
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xffF5F5F5)),
                    child: const ListTile(
                      title: Text("Aoujter une affiche"),
                      subtitle: Text(
                          "Rendez-vous dans le menu et cliqer sur 'ajouter un article', une fois dans la page de publication cliquez sur l icone en haut a gauche"),
                      trailing: CircleAvatar(
                        child: Icon(Icons.clear),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xffF5F5F5)),
                    child: const ListTile(
                      title: Text("Partager votre lien"),
                      subtitle: Text(
                          "Rendez-vous dans le menu et cliqer sur 'paramettre' dans la section reglage de compte cliquez sur partager ma boutique"),
                      trailing: CircleAvatar(
                        child: Icon(Icons.clear),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
                const Text(
                  "Statistique gbobal",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 320,
                  child: GlobalChartScreen(),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Vos produits",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (account.products.isEmpty)
                  Column(
                    children: [
                      Center(
                        child: Image.asset("assets/no_produit.png"),
                      ),
                    ],
                  )
                else
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: account.products.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            final ProductModel products =
                                account.products[index];

                            return Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xffF5F5F5)),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xffF5F5F5)),
                                    height: 150,
                                    width: 150,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        products.image[0],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        products.nom,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Prix : ${products.prix} FCFA",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "stock : ${products.stock}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          ActionChip(
                                              onPressed: () => confirmadelete(
                                                  context, products.idproduit),
                                              side: BorderSide.none,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              backgroundColor: Colors.white,
                                              label: const Text("Retirer")),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          ActionChip(
                                              onPressed: () =>
                                                  account.productsupdate(
                                                      products.idproduit,
                                                      context),
                                              side: BorderSide.none,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              backgroundColor:
                                                  const Color(0xffFFCF0D),
                                              label: const Text(
                                                "Modifier",
                                                style: TextStyle(
                                                    color: Color(0xff0D3B66)),
                                              ))
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // dialogue pour la confirmation d el asuppresion d un produit
  void confirmadelete(BuildContext context, idproduct) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text(
              "Êtes-vous sûr de vouloir continuer ?, la suppression est irrevsible"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
              child: const Text(
                "Annuler",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffFFCF0D),
              ),
              child: TextButton(
                onPressed: () {
                  DatafirestoreService.data_firestore_product
                      .doc(idproduct)
                      .delete();
                  ShowMessageComposant.messagesucces(
                      context, "Le produit a ete supprime avec sucess");
                  Navigator.of(context).pop(); // Ferme la boîte de dialogue
                },
                child: const Text("Confirmer"),
              ),
            ),
          ],
        );
      },
    );
  }

  carddata(Color colors, String nom, int nbre, Icon icon) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colors,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: icon,
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    nom,
                    style: const TextStyle(fontSize: 20),
                  ),
                )
              ],
            ),
          ),
          Text(
            nbre.toString(),
            style: const TextStyle(fontSize: 40),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text("Statistique gbobal"),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
