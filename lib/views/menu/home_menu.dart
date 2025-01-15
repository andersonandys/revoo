import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:iconsax/iconsax.dart';
import 'package:Expoplace/views/addproduct_screen.dart';
import 'package:Expoplace/views/campagne/CampagneScreen.dart';
import 'package:Expoplace/views/home_screen.dart';
import 'package:Expoplace/views/menu/menu_screen.dart';
import 'package:Expoplace/views/product_screen.dart';
import 'package:Expoplace/views/settings_screen.dart';
import 'package:Expoplace/views/stat_screen.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({Key? key}) : super(key: key);

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  MenuItemlist currentItem = MenuItems.home;

  @override
  Widget build(BuildContext context) => ZoomDrawer(
        borderRadius: 40,
        angle: -10,
        slideWidth: MediaQuery.of(context).size.width * 0.8,
        showShadow: true,
        drawerShadowsBackgroundColor: Color(0xffFFCF0D),
        menuBackgroundColor: Color(0xff0D3B66),
        mainScreen: getScreen(),
        menuScreen: Builder(
          builder: (context) => MenuScreen(
              currentItem: currentItem,
              onSelecteItem: (item) {
                setState(() => currentItem = item);

                ZoomDrawer.of(context)!.close();
              }),
        ),
      );

  Widget getScreen() {
    switch (currentItem) {
      case MenuItems.home:
        return HomeScreen();
      case MenuItems.addproduit:
        return AddproductScreen();
      case MenuItems.article:
        return ProductScreen();

      case MenuItems.stat:
        return StatScreen();
      case MenuItems.settings:
        return SettingsScreen();
      default:
        return HomeScreen();
    }
  }
}

class MenuItems {
  static const home = MenuItemlist('Dashboard', Iconsax.home);
  static const addproduit = MenuItemlist('Ajouter un article', Iconsax.box_add);
  static const article = MenuItemlist('Mes articles', Iconsax.box);
  static const settings = MenuItemlist('Paramètre', Icons.settings);
  static const stat = MenuItemlist('Mes statistiques', Iconsax.activity);

  static const all = <MenuItemlist>[
    home,
    addproduit,
    article,
    stat,
    settings,
  ];
}

class MenuItemlist {
  final String title;
  final IconData icon;

  const MenuItemlist(this.title, this.icon);
}
