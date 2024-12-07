import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Expoplace/controllers/accoun_controller.dart';
import 'package:Expoplace/models/product_model.dart';

class StatProductScreen extends StatefulWidget {
  StatProductScreen({Key? key}) : super(key: key);

  @override
  State<StatProductScreen> createState() => _StatProductScreenState();
}

class _StatProductScreenState extends State<StatProductScreen> {
  final productController = Get.put(AccounController());
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xfff4f7fa)),
              child: ExpansionTile(
                expandedAlignment: Alignment.topLeft,
                title: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Produits les plus visités",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0D3B66),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Retrouver les statistiques des produits les plus visités',
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                children: [
                  if (productController.accountdata.value!.offre == "premium" ||
                      productController.accountdata.value!.offre ==
                          "entreprise")
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: productController.products.length,
                        itemBuilder: (BuildContext context, int index) {
                          ProductModel product =
                              productController.products[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                product.image[0],
                              ),
                            ),
                            title: Text(product.nom),
                            subtitle: Text(
                              product.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: CircleAvatar(
                              backgroundColor: Colors.amberAccent,
                              child: Text("${product.nbrevisite}"),
                            ),
                          );
                        },
                      ),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Accès limité à cette statistique Votre plan actuel ne vous permet pas d'accéder à cette fonctionnalité. \n Pour en bénéficier, nous vous invitons à passer à un plan incluant les statistiques avancées.",
                        style: TextStyle(),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
