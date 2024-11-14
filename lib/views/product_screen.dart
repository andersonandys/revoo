import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:revoo/composant/menu_composant.dart';
import 'package:revoo/composant/show_message_composant.dart';
import 'package:revoo/controllers/accoun_controller.dart';
import 'package:revoo/models/product_model.dart';
import 'package:revoo/service/datafirestore_service.dart';
import 'package:revoo/views/update_setting/product_update_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final product = Get.put(AccounController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Produits"),
          centerTitle: true,
          leading: const MenuWidget()),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(10),
          child: (product.products.isEmpty)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset("assets/no_produit.png"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Vous n'avez pas encore publié de produit",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )
                  ],
                )
              : SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      ListView.builder(
                        itemCount: product.products.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          final ProductModel products = product.products[index];

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
                                Container(
                                  child: Column(
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
                                                  product.productsupdate(
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
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
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
}
