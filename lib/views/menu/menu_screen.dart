import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revoo/controllers/accoun_controller.dart';
import 'package:revoo/views/menu/home_menu.dart';

class MenuScreen extends StatelessWidget {
  late MenuItemlist currentItem;
  late ValueChanged<MenuItemlist> onSelecteItem;
  MenuScreen({required this.currentItem, required this.onSelecteItem});
  final account = Get.put(AccounController());
  @override
  Widget build(BuildContext context) => Theme(
        data: ThemeData.light(),
        child: Scaffold(
          backgroundColor: Color(0xff0D3B66),
          body: SafeArea(
            child: Obx(
              () => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Spacer(),
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 35,
                                backgroundImage: NetworkImage(
                                    account.accountdata.value!.avatar),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                account.accountdata.value!.name,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ...MenuItems.all.map(buildMenuItem).toList(),
                          const Spacer(
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      "Copyrigth REVOO",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  Widget buildMenuItem(MenuItemlist item) => Row(
        children: <Widget>[
          if (currentItem == item)
            Container(
              height: 20,
              width: 2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Color(0xffFFCF0D)),
            ),
          Expanded(
              child: ListTile(
            selected: currentItem == item,
            minLeadingWidth: 20,
            leading: Icon(
              item.icon,
              color: Colors.white,
            ),
            title: Text(
              item.title,
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => onSelecteItem(item),
          ))
        ],
      );
}
