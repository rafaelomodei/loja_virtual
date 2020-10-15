import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojavirtual/models/user_manager.dart';
class AdminUsersManager extends ChangeNotifier{
  //verifica se o user é adm, assim não gasta net do usuer comum

  List<User> users = [];

  final Firestore firestore = Firestore.instance;
  StreamSubscription _subscription; //usado para matar o processo, para nao fica atualizando mesmo que o nosso app esteja fexado

  void updateUser(UserManager userManager){
    // o ? é se o _subscription for null ele não executa essa função
    _subscription?.cancel(); // mata o processo para não buscar o usur, isso pq se o user não for adm ele não precisa carregar a lista de user
    //assim economiza os dados(internet) do usuário
    if(userManager.adminEnabled){
      _listenToUsers(); // para atualizar em tempo real

    }else{ //caso o adm seja outro é reciso limpar a lista de user e carregar uma nova
      //assim o adm nao fica com a lista bagunçada, com user que não é dele
      users.clear();
      notifyListeners();
    }
  }

  void _listenToUsers(){
      //_subscription recebe os dados do banco para assim depois eu matar ele
      _subscription = firestore.collection('users').snapshots().listen((snapshot){ //acessa o banco e pega tudo que tem dentro de users
        users = snapshot.documents.map((e) => User.fromDocument(e)).toList(); //passa para a variável users cada documento e
        users.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())); //ordena de forma alfabetica
        notifyListeners(); //atualiza
      });

  }

  List<String> get names => users.map((e) => e.name).toList();

  @override
  void dispose() {
    _subscription?.cancel(); //mata o processo _subscription
    dispose();
  }


}