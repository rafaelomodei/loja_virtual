//representa cada card, cada item do carrinho

import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/item_size.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartProduct extends ChangeNotifier{
  CartProduct.fromProduct(this.product){
    productId = product.id;
    quantity = 1;
    size = product.selectedSize.name;
  }

  CartProduct.fromDocument(DocumentSnapshot document){
        id = document.documentID;
        productId = document.data['pid'] as String;
        quantity = document.data['quantity'] as int;
        size = document.data['size'] as String;

        //busca o produto
        firestore.document('products/$productId').get().then(
                (doc){
                  product = Product.fromDocument(doc);
                  notifyListeners();
                }
        );
  }

  //instancia o firestore
  final Firestore firestore = Firestore.instance;

  String id; //id do cartProduct, sem ele não sei qual item atualizar no carrinho

  String productId;
  int quantity;
  String size;

  Product product;

  //busca o tamanho do produto
  ItemSize get itemSize{
    if(product == null) return null;
    return product.findSize(size);
  }

  //busca o valor do produto
  num get unitPrice{
    if(product == null) return 0;
    return itemSize?.price ?? 0; // o ? do itemSize é caro o item seja nulo
  }

  num get totalPrice => unitPrice * quantity;

  //dynamic o formato ue vamos salvar no firebase
  Map<String, dynamic>toCartItemMap(){
    return{
      //campo do banco de dados | valor a ser atribuido
      'pid': productId,
      'quantity': quantity,
      'size' : size,
    };
  }

  //junta os produtos no carrinho, pelo id ou pelo tamanho
  bool stakable(Product product){
    //product.id o produto que eu quero add ao carrinho tem o mesmo id do  produto que está no carrinho
    //productId produto que já está no carrinho
    //product.selectedSize.name o produto que eu selecionei e querro add ao carrinho tem o mesmo tamanho
    //size tamanho do ite que já esta no carrinho
      return product.id == productId && product.selectedSize.name == size;
  }

  void increment(){
    quantity++;
    notifyListeners();
  }

  void decrement(){
    quantity--;
    notifyListeners();
  }

  //verifica se tem estoque
  bool get hasStock{
    final size = itemSize; //recebe a quantidade de item que tem no estoque
    if(size == null) return false;
    return size.stock >= quantity;
  }

}