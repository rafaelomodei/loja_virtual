//Gerenciador de usuário
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:lojavirtual/helpers/firebase_errors.dart';
import 'package:lojavirtual/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManager extends ChangeNotifier { // ChangeNotifier para pode usar notifyListeners que vai avisa para todos que estão observando que ouve alteração

  UserManager(){
    _loadCurrentUser(); //vai set acessado de fora, por isso coloca-se privado
  }

  final FirebaseAuth auth = FirebaseAuth.instance; //para não ficar escrevendo toda vez FirebaseAuth.instance
  final Firestore firestore = Firestore.instance;

  User user; //com esse user posso acessa ele de qualquer lugar do app


  bool _loading = false; //carregamento como false
  bool get loading => _loading; //acessa a variavel _loading precisa disso pq ela é privada

  bool get isLoggedIn => user != null; //verifica se o user etsá logado

  Future<void> signIn({User user, Function onFail, Function onSuccess}) async {
    //async pq a função demra um tempo para acontecer e por isso retorna um Futuro
    loading = true; //ativa o bloquei dos campos
    try {
      final AuthResult result = await auth.signInWithEmailAndPassword(
          //await é usado quando se usa uma função async
          email: user.email,
          password: user.password);

      await _loadCurrentUser(firebaseUser: result.user);

      onSuccess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false; //desativa o bloquei dos campos
  }

  //logar usuário
  Future<void> sinUp({User user, Function onFail, Function onSuccess}) async{
    loading = true;
    try{
      final AuthResult result = await auth.createUserWithEmailAndPassword( //createUserWithEmailAndPassword ele faz várias verificaçãos se pode ou não cadastrar o usuário com aquele e-mail
          email: user.email, password: user.password);

      user.id = result.user.uid; //pega o id do usuário

      this.user = user;

      //await, espera os dados serem salvo para exibir sucesso
      await user.saveData();
      onSuccess();
    }on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  //deslogar o usuário
  void signOut(){
    auth.signOut(); //desloga do firebase
    user = null; //usuário fica nulo
    notifyListeners(); //notifica que o usuáro deslogou
  }

  //muda o estado de true/false do carregamento
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  // mostra uma bolinha carregando para o usuário
  Future<void> _loadCurrentUser({FirebaseUser firebaseUser}) async {
    final FirebaseUser currentUser = firebaseUser ?? await auth // o ?? é tipo um if, se o firebaseUser != null ele pega o objeto passado pelo parametro se ele pega o user atual no firebase
        .currentUser(); //pega o usuario que esta fazendo o login
    if (currentUser != null) {
      //pegando os dados do usuário no banco de dados
      final DocumentSnapshot docUser = await firestore.collection('users')
          .document(currentUser.uid).get();

      user = User.fromDocument(docUser);

      print(user.name);
      notifyListeners(); //notifica a galera
    }
  }
}
