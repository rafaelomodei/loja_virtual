import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custom_drawer/custom_drawer.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:lojavirtual/models/product_manager.dart';
import 'package:lojavirtual/screens/products/components/products_list_tile.dart';
import 'package:provider/provider.dart';

import 'components/Search_dialog.dart';

class ProductsScreen extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      //coloca o drawer na tela produtos, se não colocar fica a seta para voltar
      appBar: AppBar(
        title: Consumer<ProductManager>(builder: (_, productManager, __) {
          if (productManager.search.isEmpty) {
            return const Text(
              'Produtos',
            );
          } else {
            return LayoutBuilder(
                //usa o LayoutBuilder para pegar informações do tipo, largura, autura etc..
                builder: (_, constraints) {
              return GestureDetector(
                  onTap: () async {
                    final search = await showDialog<String>(
                        context: context,
                        //search vai pegar o resutado da busca, o user clica em algum lugar para presquisar
                        builder: (_) =>
                            //passa como parametro o que foi escrito na pesquisa
                            SearchDialog(productManager.search)); //caso clique para voltar ou onde nao tem nada, ele retorna null
                    if (search != null) {
                      productManager.search = search;
                    }
                  },
                  child: Container(
                      width: constraints.biggest.width,
                      //pego o tamanho maximo da largura, assim podemos clicar em qualquer lugar do appBar para eferuar uma nova pesquisa,
                      child: Text(
                          productManager.search,
                        textAlign: TextAlign.center,

                      )));
            });
          }
        }),
        centerTitle: true,
        actions: <Widget>[
          Consumer<ProductManager>(
            builder: (_, productManager, __) {
              if (productManager.search.isEmpty) {
                return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    //ao clicar no botão, aparece uma caixa de dialogo, o show dialog é do tipo String pq ele pode retornar qualquer valor dynamic , netão nos especifica ele para só retornar do tipo String
                    final search = await showDialog<String>(
                        context: context,
                        //search vai pegar o resutado da busca, o user clica em algum lugar para presquisar
                        builder: (_) =>
                            SearchDialog(productManager.search)); //cas clique para voltar ou onde n~~ao tem nada, ele retorna null
                    if (search != null) {
                      productManager.search = search;
                    }
                  },
                );
              } else {
                return IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    productManager.search =
                        ''; //se clicar no icone X a pesquisa ficaem branco fazendo que que sai do modo de pesquisa
                  },
                );
              }
            },
          )
        ],
      ),
      body: Consumer<ProductManager>(//Consumer para acessar os produtos
          builder: (_, productManager, __) {
        final filterProducts = productManager
            .filteredProducts; //com essa variavel não preciso fica fazendo a busca toda vez
        return ListView.builder(
            padding: const EdgeInsets.all(5),
            //usa o metodo builder para ir renderizando os produtos conforme vai rolando a tela
            itemCount: filterProducts.length,
            //filteredProducts ja filtra os produtos
            itemBuilder: (_, index) {
              return ProductListTile(filterProducts[index]);
            });
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        onPressed: (){
          Navigator.of(context).pushNamed('/cart');
        },
      ),
    );
  }
}
