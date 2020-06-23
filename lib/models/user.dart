//Todos os dados do usuário
//Criando um usuário objeto fica mais simples de trabalhar com a aplicação
import 'package:cloud_firestore/cloud_firestore.dart';
class User{

  User({this.email, this.password, this.name, this.id});
  User.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    name = document.data['name'] as String; //como a variavel name não pode receber um valor dinamico, faz a conversão para String usando "as String"
    email = document.data['email'] as String; //o mesmo ocorre aqui
  }

  String id;
  String name;
  String email;
  String password;

  String confirmPassword;

  //Seta o local onde vai se armazenado as funções
  DocumentReference get firestorRef =>
      Firestore.instance.document('users/$id');

  //vai entrar no banco de dados e vai salvar todos os dados o usuário
  Future<void> saveData() async{
    //recebe o mapa (toMap) do usuário
    await firestorRef.setData(toMap());
  }

  //Transforma os dados importante do usuário em um mapa
  //dynamic é o formato do map que o firebase aceita
  Map<String, dynamic> toMap(){
    return{
      'name' : name,
      'email': email,
    };
  }
}