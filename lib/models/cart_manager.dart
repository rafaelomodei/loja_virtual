//Gerenciador do carrinho

import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/cart_product.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:lojavirtual/models/user.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartManager extends ChangeNotifier{
  List<CartProduct> items = []; //Carrinho de compras

  //para pegar o useer que está logado
  User user;

  //somar o carrinho
  num productsPrice = 0.0;

  //a função que informa se teve attualização no userManager
  void updateUser(UserManager userManager){
      user = userManager.user; //salva o user que está logado
      items.clear(); //limpa o carrinho

    if(user != null){
      _loadCartItems();
    }
  }

  Future<void> _loadCartItems() async{
    //salva todos os itens do carrinho que estava no banco de daodos na variavel cartSnap
    final QuerySnapshot cartSnap =  await user.cartReference.getDocuments();

    //addListener para atualizar as informações que ve do banco de dados
    items = cartSnap.documents.map(
            (d) => CartProduct.fromDocument(d)..addListener(_onItemUpdated)
    ).toList();
  }

  //adicionar um item ao carrinho
  void addToCart(Product product){
    try {
      //'e' siguinifica entidade
      //stakable essa função é responsavel por juntar os itens iguais
      final e = items.firstWhere((p) => p.stakable(product));
      //se o item for igual que já tem no carrinho, então encrementa
      e.increment();
    }catch(e){
      //CartProduct.fromProduct usado para transforma o produto no formato aceitavel
      final cartProduct = CartProduct.fromProduct(product);

      cartProduct.addListener(_onItemUpdated);

      items.add(cartProduct);
      //cartProduct para ser adcionado ao banco tem que ser um map
      user.cartReference.add(cartProduct.toCartItemMap())
          .then((doc) => cartProduct.id = doc.documentID);
      _onItemUpdated(); //chama manual para dar update nos itens
    }
    notifyListeners();
  }

  //procura um item para remover
  void removeOfCart(CartProduct cartProduct){
    //p é o objeto CartProduct onde pega o id dele e compara com  cartProduct
    //se for igual ele remove
    items.removeWhere((p) => p.id == cartProduct.id);
    user.cartReference.document(cartProduct.id).delete();
    //remove o item da Listener, se não remover pode prejudicar a performace
    // e gerar bug no app
    cartProduct.removeListener(_onItemUpdated);
    notifyListeners();
  }

  //pega cada item do cartProduct
  void _onItemUpdated(){
    productsPrice = 0.0;

    for(int i = 0; i < items.length; i++){
      final cartProduct = items[i];

      if(cartProduct.quantity ==0){
        removeOfCart(cartProduct); //remove o card da tela do user
        i--;
        continue; //ele pula tod_o o restante e volta para o inicio do for
      }

      //preço total
      productsPrice += cartProduct.totalPrice;

      _updateCartProduct(cartProduct);
    }
    notifyListeners(); //notifica a galera
  }


  //atualiza as
  void _updateCartProduct(CartProduct cartProduct){
    if(cartProduct.id != null)
      //documento correspondente do nosso carrinho
      user.cartReference.document(cartProduct.id)
          .updateData(cartProduct.toCartItemMap());
  }

  //valida o carrinho
  bool get isCartValid{
    // verifica todos os itens do carrinho se tem estoque
    for(final cartProduct in items){
      if(!cartProduct.hasStock) return false;
    }
    return true;
  }

}
