//Gerenciador de produto

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/product.dart';

class ProductManager extends ChangeNotifier {
  //nosso construtor vai baixar todos os produtos do banco de uma vez e retornar para nos
  ProductManager() {
    _loadAllProducts();
  }

  //instancia o banco de dados, usa a variavel para nao fica instanciando toda vez que for acessar o banco
  final Firestore firestore = Firestore.instance;

  List<Product> allProducts = []; //cria uma lista privada de produtos

  //variável de busca
  String _search = ''; //ele tem que iniciar vazio, pq se não da erro, devido as comparações que nos fazemos na função search
  String get search => _search; //get retorna o que tem dentro de search

  //seta um valor em search
  set search(String value) {
    _search = value;
    notifyListeners(); //avisa quando teve alteração
  }

  //pega os itens com a caracterisca passada em search
  List<Product> get filteredProducts {
    final List<Product> filteredProducts = []; //lista com os itens filtrados

    if (search.isEmpty) {
      //se a pesquisa está vazia, add todos os itens
      filteredProducts.addAll(allProducts);
    } else {
      //pega todos os itens do banco, converte para minuscuto e compara com o search em minusculo também
      filteredProducts.addAll(allProducts.where((p) => p.name
          .toLowerCase()
          .contains(search
              .toLowerCase()))); //filtra os itens que esta passando pelo serach
    }

    return filteredProducts;
  }

  //
  Future<void> _loadAllProducts() async {
    //exatamente aqui que pega todos os produtos no bancp
    final QuerySnapshot snapProducts =
        await firestore.collection('products').getDocuments();

    allProducts = snapProducts.documents
        .map(
            //pega todos os documentos coloca na variavel d e transforma em uma lista
            (d) => Product.fromDocument(d)).toList();

    notifyListeners(); //informa a galera que ouve alteração na lista de produtos
  }

  Product findProductByID(String id){
   try{
     return allProducts.firstWhere((p) => p.id == id);
   }catch(e){
     return null;
   }
  } 
}