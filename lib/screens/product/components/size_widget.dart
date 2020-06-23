import 'package:flutter/material.dart';
import 'package:lojavirtual/models/item_size.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:provider/provider.dart';

class SizeWidget extends StatelessWidget {

  const SizeWidget({this.size});

  final ItemSize size;

  @override
  Widget build(BuildContext context) {

    final product = context.watch<Product>();
    final selected = size == product.selectedSize; //recebe qual produto está celecionado
    Color color;

    if(!size.hasStock)
        color = Colors.red.withAlpha(50);
    else if(selected)
      color = Theme.of(context).primaryColor;
    else
      color = Colors.grey;


    return GestureDetector(
      onTap: (){
        if(size.hasStock){ //não deixa o tem que não tem estoque ser selecionado
          product.selectedSize = size; //pasa o produto que foi selecionado
        }
      },

      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
          color: color, //caso o estoque fica vermelho  meio trans parente, caso tenha fica cinza
          )
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, //faz com que o widget fique no menor tamanho possivel
          children: <Widget>[
            Container(
              color: color,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                size.name,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'R\$ ${size.price.toStringAsFixed(2)}', // toStringAsFixed rece a quantidade de casas decimais a pos a virgula),
                  style: TextStyle(
                    color: color,
      ),
      ),
            ),
          ],
        ),
      ),
    );
  }
}
