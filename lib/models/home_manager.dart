import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/section.dart';

class HomeManager extends ChangeNotifier{

  HomeManager(){
    /*Carrega todos os dados da home*/
    _loadSections();
  }

  List<Sections> sections = [];

  final Firestore firestore = Firestore.instance;

  Future<void> _loadSections() async{
    /*Acessa a coleção home e pega todos os produtos*/
    firestore.collection('home').snapshots().listen((snapshot){
      /*Limpa toda alista, para não ocorrer duplicações*/
      sections.clear();
      /*Pega cada produto e transforma em um objeto*/
      for(final DocumentSnapshot document in snapshot.documents){
          sections.add(Sections.fromDocument(document)); //adicona o produto a lista
      }
      notifyListeners();
    });
  }
}