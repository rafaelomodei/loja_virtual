import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custom_drawer/custom_drawer.dart';
import 'package:lojavirtual/models/home_manager.dart';
import 'package:provider/provider.dart';

import 'components/section_List.dart';
import 'components/section_staggered.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(

      ),
      //Para o drawer aparecer precisa da appbar e essa app bar é de scrolar
      //ela aparece e some conforme sobe e desce a tela
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green[900],
                  Colors.green[500]
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
              )
            ),
          ),
         CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              snap: true,
              floating: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: const FlexibleSpaceBar(
                title: Text('Loja do Rafael'),
                centerTitle: true,
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  color: Colors.white,
                  onPressed: () => Navigator.of(context).pushNamed('/cart'),
                )
              ],
            ),
           Consumer<HomeManager>(
             builder: (_, homeManager, __){
               final List<Widget> children = homeManager.sections.map<Widget>(
                       (section){
                            switch(section.type){
                              case 'List':
                                return SectionList(section);
                              case 'Staggered':
                                return SectionStaggered(section);
                              default:
                                return Container();
                            }
                   }).toList();
               return SliverList(
                 delegate: SliverChildListDelegate(children),
               );
             }
           )
          ]
        ),
        ],
      ),
    );
  }
}
