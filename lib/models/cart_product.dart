//representa cada card, cada item do carrinho

import 'package:lojavirtual/models/item_size.dart';
import 'package:lojavirtual/models/product.dart';

class CartProduct{
  CartProduct.fromProduct(this.product){
    productId = product.id;
    quantity = 1;
    size = product.selectedSize.name;
  }

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

}