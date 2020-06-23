import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:provider/provider.dart';

import 'components/size_widget.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    //criase um ChangeNotifierProvider aqui pq eu quero ter o controle de um item especifico só nesta tela,
    // então não faz sentido add em outra
    // o .value é para forcecer um objeto
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(product.name),
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1, //deixa a imagem quadrada
              child: Carousel(
                images: product.images.map((url) {
                  //pego uma lista da imagens
                  return NetworkImage(
                      url); //retorno as imagens apartir de um link
                }).toList(),
                dotSize: 4,
                //diminui a espessura da barra onde fica as bolinhas
                dotBgColor: Colors.transparent,
                //deixa a barra transparente
                dotColor: primaryColor,
                //coloca a cor das bolinhas como cor primaria
                autoplay:
                    false, //desativa o modo de ficar passando a imagem automaticamente
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    product.name,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: primaryColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      'A partir de',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Text(
                    'R\$ 4.50',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  Text(
                    'Descrição',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'Pesos',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Wrap( //Wrap é usado para colocar diversors widget na tela como se fosse uma linha, caso não tiver epaço ele quebra a linha
                    spacing: 8,
                    runSpacing: 8,
                    children: product.sizes.map((s){ //o s é o tamanho que deve ser criado o widget
                      return SizeWidget(size: s);
                    }).toList(),
                  ),
                  const SizedBox(height: 20,),
                  if(product.hasStock) // se tiver estoque exibe o botão
                    Consumer2<UserManager, Product>( //Consumer2 é genial, pq podemos monitorar duas coisas totalmente distintas
                      builder: (_, userManager, product, __){
                        return SizedBox( //para ajustar a altura do botão

                          height: 44,
                          child: RaisedButton(
                            onPressed: product.selectedSize != null ? (){ //verifica se o user selecionou algum item
                                if(userManager.isLoggedIn){
                                  context.read<CartManager>().addToCart(product); // passa o produto para o carrinho
                                  Navigator.of(context).pushNamed('/cart');
                                }else{
                                  Navigator.of(context).pushNamed('/login');
                                }
                            }: null,
                            color: primaryColor, //linda essa declaração <3 economia de codigo, pq o primaryColor é usado em vários locais
                            textColor: Colors.white,
                            child: Text(
                              userManager.isLoggedIn //verifica se o user está logado
                                  ? 'Adicionar ao Carrinho'
                                  : 'Entre para Camprar',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      },
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
