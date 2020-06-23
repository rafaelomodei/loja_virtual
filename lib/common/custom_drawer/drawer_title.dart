//DrawerTitle é um item do menu
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/page_manager.dart';
import 'package:provider/provider.dart';


//Stateless por não sofrer modificações
class DrawerTitle extends StatelessWidget {

  const DrawerTitle({this.iconData, this.title, this.page}); //contrutor

  final IconData iconData; //Icone de cada item
  final String title; //titulo de cada item
  final int page; //Para saber qual pagina estou acessando

  @override
  Widget build(BuildContext context) {


    final int curPage = context.watch<PageManager>().page; //fica monitorando a pagina atual
    final Color primaryColor = Theme.of(context).primaryColor; //pega a cor primaria

    return InkWell(
      onTap: (){
        context.read<PageManager>().setPage(page);
      },
      child: SizedBox(
      height: 60,
        child:Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Icon(
              iconData,
              size: 32,
              color: curPage == page ? primaryColor : Colors.blueGrey,
            ),
          ),
          Text(
              title,
            style: TextStyle(
              fontSize: 16,
              color: curPage == page ? primaryColor : Colors.blueGrey//cor do texto
            ),
          ),
        ],
        )
      ),
    );
  }
}
