//Objeto para alterar e ou saber em qual pagina estamos de qualquer lugar
//Via provider
import 'package:flutter/cupertino.dart';

class PageManager{

  //Construtor recebendo pageController como parametro
  PageManager(this._pageController);

  //cria o construtor
  final PageController _pageController;

  int page = 0; //essa variavel é para ter um controle que qual pagina está, assim não precisa fica recaregando a pagina que já sendo visivel

  //Função que vai fazer a navegação entre as paginas
  void setPage(int value){
    if(value == page) return;
    page = value;
    //jumpToPage leva para pagina passada pelo indice
    _pageController.jumpToPage(value);
  }
}

