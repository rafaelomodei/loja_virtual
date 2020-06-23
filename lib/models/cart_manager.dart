//Gerenciador do carrinho

import 'package:lojavirtual/models/cart_product.dart';
import 'package:lojavirtual/models/product.dart';

class CartManager{
  List<CartProduct> items = []; //Carrinho de compras

  //adicionar um item ao carrinho
  void addToCart(Product product){
    //CartProduct.fromProduct usado para transforma o produto no formato aceitavel
      items.add(CartProduct.fromProduct(product));
  }

}