import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojavirtual/models/admin_users_manager.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:lojavirtual/screens/base/base_screen.dart';
import 'package:lojavirtual/screens/cart/cart_screen.dart';
import 'package:lojavirtual/screens/login/login_screen.dart';
import 'package:lojavirtual/screens/product/product_screen.dart';
import 'package:lojavirtual/screens/signup/signup_screen.dart';
import 'package:provider/provider.dart';

import 'models/home_manager.dart';
import 'models/product_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MultiProvider( //MultiProvider usado para ter multiplos provaider
      providers: [
        ChangeNotifierProvider(
            create: (_) => UserManager(), //Cria o provider para pode acessar de qualquer lugar
            lazy: false, //se deixar lazy como true ele só vai carregar o UserManager quando for preciso exibir ele em algu local
          ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        //toda vez que o UserManager tiver attualizado o CartManager também att
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false, //com false ele já carreg o carrinho quando abre o app
          update: (_, userManager, cartManager) =>
          //injeta p userManager no cartManager para ele saber se teve alteração
          cartManager..updateUser(userManager), // o .. é efeito cascata
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManager, adminUsersManager) =>
          adminUsersManager..updateUser(userManager),
        ),
      ],
      child: MaterialApp(
        title: 'Loja do Rafael',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.green[900],
            scaffoldBackgroundColor: Colors.green[900],
            appBarTheme: const AppBarTheme(elevation: 0),
            //zera as elevação do appbar
            visualDensity: VisualDensity.adaptivePlatformDensity
        ),
        //initialRoute recebe a pagina inicial, onde o app vai abrir
        initialRoute: '/base',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(
                  builder: (_) => LoginScreen()
              );
            case '/product':
              return MaterialPageRoute(
                  builder: (_) => ProductScreen(
                    settings.arguments as Product //passa o produto como parametro, o argumento é dynamic
                  )
              );
            case '/signup':
              return MaterialPageRoute(
                  builder: (_) => SignUpScreen()
              );
            case '/cart':
              return MaterialPageRoute(
                  builder: (_) => CartScreen()
              );
            case '/base': //stranho mas funciona kkk
            default: //base retorna a mesma coisa de default
              return MaterialPageRoute(
                  builder: (_) => BaseScreen()
              );
          }
        },

      ),
    );
  }
}
