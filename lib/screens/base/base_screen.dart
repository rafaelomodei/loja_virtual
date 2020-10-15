import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custom_drawer/custom_drawer.dart';
import 'package:lojavirtual/models/page_manager.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:lojavirtual/screens/admin_users/admin_users_screens.dart';
import 'package:lojavirtual/screens/home/home_screen.dart';
import 'package:lojavirtual/screens/login/login_screen.dart';
import 'package:lojavirtual/screens/products/products_screen.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {

  final PageController pageController = PageController();


  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: Consumer<UserManager>(
        builder: (_, userManager, __){
          return PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              HomeScreen(),
              ProductsScreen(),
              Scaffold(
                drawer: CustomDrawer(),
                appBar: AppBar(
                  title: Text('Home 3'),
                ),
              ),
              Scaffold(
                drawer: CustomDrawer(),
                appBar: AppBar(
                  title: Text('Home 3'),
                ),
              ),

              if(userManager.adminEnabled)
                // o que os pontinho faz ?
                //ele adiciona os itens que estão dentro do [] na lista ja existente
                //Exemplo mais claro: List<int> lista = [1, 2, 3, ...[4, 5]]
                //pode usar condições também:  List<int> lista = [1, 2, 3, if(false)...[4, 5]]
                ...[
                  AdminUsersScreen(),
                  Scaffold(
                    drawer: CustomDrawer(),
                    appBar: AppBar(
                      title: Text('Pedidos'),
                    ),
                  ),
                ]

            ],
          );
        },
      ),
    );
  }
}
