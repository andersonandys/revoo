import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:revoo/composant/menu_composant.dart';
import 'package:revoo/controllers/accoun_controller.dart';
import 'package:revoo/models/product_model.dart';
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
                  MasonryGridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: account.products.length,
                    itemBuilder: (BuildContext context, int index) {
                      ProductModel product = account.products[index];
                      return Container(
                        padding: const EdgeInsets.all(10),
                        height: index.isEven
                            ? 250
                            : 270, // Hauteur variable selon l'index
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xffF5F5F5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                            )),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              product.nom,
                              style: TextStyle(fontSize: 17),
                            ),
                            Text(
                              "prix : ${product.prix} FCFA",
                              style: TextStyle(fontSize: 17),
                            ),
                            Text(
                              "Stock :  ${product.stock}",
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                      );
                    },
                  )
              ],
            ),
          ),
        ),
      ),
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
