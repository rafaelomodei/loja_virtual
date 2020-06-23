//vai ser o card do produto que vai aparece em produtos

import 'package:flutter/material.dart';
import 'package:lojavirtual/models/product.dart';

class ProductListTile extends StatelessWidget {

  const ProductListTile(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector( //se clicar no card vai para tela do produto
      onTap: (){
        Navigator.of(context).pushNamed('/product', arguments: product);//vai para tela do produto, passa o produto por parametro
      },
      child: Card(
        shape: RoundedRectangleBorder( //deixa a borda arrendondada
          borderRadius: BorderRadius.circular(4)
        ),
        child: Container( //usa o container para  ajustar a altura
            height: 100,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1,//deixa a imagem quadrada
                child: Image.network(product.images.first), //first seria a mesma coisa se pega-se o indece 0
              ),
              const SizedBox(width: 16,),
              Expanded( //para pegar toda a largura reatante do card
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'A partir de',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Text(
                      'R\$ 4.50',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                  ],
                ),

              )
            ],
          ),
        ),
      ),
    );
  }
}
