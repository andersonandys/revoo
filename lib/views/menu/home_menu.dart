import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:iconsax/iconsax.dart';
import 'package:revoo/views/addproduct_screen.dart';
import 'package:revoo/views/campagne/CampagneScreen.dart';
import 'package:revoo/views/home_screen.dart';
import 'package:revoo/views/menu/menu_screen.dart';
import 'package:revoo/views/product_screen.dart';
import 'package:revoo/views/settings_screen.dart';
import 'package:revoo/views/stat_screen.dart';

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
      case MenuItems.campagne:
        return CampagneScreen();
      case MenuItems.stat:
        return StatScreen();
      case MenuItems.settings:
        return SettingsScreen();
      case MenuItems.deconnexion:
        return Container();
      default:
        return HomeScreen();
    }
  }
}

class MenuItems {
  static const home = MenuItemlist('Dashboard', Icons.payment);
  static const addproduit = MenuItemlist('Ajouter un article', Iconsax.box_add);
  static const article = MenuItemlist('Mes articles', Iconsax.box);
  static const settings = MenuItemlist('Paramettre', Icons.settings);
  static const campagne = MenuItemlist('Campagne', Icons.ads_click);
  static const stat = MenuItemlist('Mes statistiques', Iconsax.activity);
  static const deconnexion = MenuItemlist('Deconnexion', Icons.logout_rounded);
  static const all = <MenuItemlist>[
    home,
    addproduit,
    article,
    campagne,
    stat,
    settings,
    deconnexion
  ];
}

class MenuItemlist {
  final String title;
  final IconData icon;

  const MenuItemlist(this.title, this.icon);
}
