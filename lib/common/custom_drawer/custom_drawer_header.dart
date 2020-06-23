import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class CustomDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 24, 16, 8),
      height: 180, //altura do cabeçalho
      child: Consumer<UserManager>(
        builder: (_, userManager, __){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start, //coloca a galera no inicio da linha
            mainAxisAlignment: MainAxisAlignment.spaceAround, //os texto ganha espaço
            children: <Widget>[
              Text(''
                  'Loja do\nRafael',
                style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'Olá, ${userManager.user?.name ?? ''}', // pega o nome do user, caso seja nulo colo '' vazio
                overflow: TextOverflow.ellipsis, //caso o nome do user seja muito grande vai da merda entao isso resolve, fazendo uma quebra
                maxLines: 2, //quantidade de linhas que pode ser divido o nome do usuário
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector( //botão de sair
                onTap: (){
                  if(userManager.isLoggedIn){ //verifica se o user talogado
                    userManager.signOut(); //desloca o usuário
                  }else{
                    Navigator.of(context).pushNamed('/login'); //vai para tela de login
                  }
                },
                child: Text(
                  userManager.isLoggedIn //verifica se o usuário está logado
                      ? 'Sair'
                      : 'Entre ou cadastre-se',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
