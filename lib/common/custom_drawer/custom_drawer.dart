//CustomDrawer Para customizar o menu
import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custom_drawer/custom_drawer_header.dart';
import 'package:lojavirtual/common/custom_drawer/drawer_title.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          //Sefor colocar gradient é só add um container e gg

          ListView(
            children: <Widget>[
              CustomDrawerHeader(),
              const Divider(),
              DrawerTitle(iconData: Icons.home, title: 'Inicio', page: 0,),
              DrawerTitle(iconData: Icons.list, title: 'Produtos', page: 1,),
              DrawerTitle(iconData: Icons.playlist_add_check, title: 'Meus Produtos', page: 2,),
              DrawerTitle(iconData: Icons.location_on, title: 'Lojas', page: 3),

            ],
          ),
        ],
      ),
    );
  }
}
