//caixa de pesquisa de produto

import 'package:flutter/material.dart';

class SearchDialog extends StatelessWidget {

  const SearchDialog(this.initialText);

  final String initialText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          //posiciona a barra de pesquisa no topo
          top: 2,
          left: 5,
          right: 5,
          child: Card(
            child: TextFormField( //campo para inserir o texto
              initialValue: initialText,
              textInputAction: TextInputAction.search,
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none, //remove a borda
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                prefixIcon:  IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
              ),
              onFieldSubmitted: (text){
                Navigator.of(context).pop(text);
              },
            ),
          ),
        ),
      ],
    );
  }
}
