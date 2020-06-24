//Com essa classe vamos pode acessar o nosso objeto de qualquer lugar, o mesmo ocorre com o usuario

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/item_size.dart';

class Product extends ChangeNotifier {
  //nosso construtor que vai coletar os dados do banco de dados
  Product.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    name = document['name'] as String;
    description = document['description'] as String;
    images = List<String>.from(document.data['images'] as List<
        dynamic>); //receber as imagens do banco, como o banco retorna uma lista dinamica e nos tem uma lista de string é nescessario fazer desta forma, só que tem que confirmar que estamos recebendo uma lista dynamic
    sizes = (document.data['sizes'] as List<dynamic> ?? [])
        .map((s) => ItemSize.fromMap(s as Map<String, dynamic>))
        .toList(); //pega cada um dos tamanho e cia um item size
  }

  String id;
  String name;
  String description;
  List<String> images; //lista de imagens
  List<ItemSize> sizes; //pega o tamanho do produto

  ItemSize _selectedSize; //para pegar qual tamanho/peso foi selecionado

  ItemSize get selectedSize => _selectedSize;

  set selectedSize(ItemSize value) {
    _selectedSize = value;
    notifyListeners();
  }

  //obtemos o numero total de itens no estoque, assim podemos usar pra renderizar o botão de add ao carrinho ou não
  int get totalStock {
    //vai percorrer tod_o o estoque e adicionar a uma variavel
    int stock = 0;
    for (final size in sizes) {
      stock += size.stock;
    }
    return stock;
  }

  bool get hasStock {
    return totalStock > 0;
  }

  //encontrar o item correspondente ao tamanho
  //o item é o item que foi salvo no firebase
  ItemSize findSize(String name){
    // a esseção é caso um determinado tamanho seja removido
    //então se ele for removido retorna null
    try {
      return sizes.firstWhere((s) => s.name == name);
    }catch(e){
      return null;
    }
  }

}
