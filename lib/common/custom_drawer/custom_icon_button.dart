import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {

  //passo o icon por parametro qeu assim posso passar qualquer um
  const CustomIconButton({this.iconData, this.color, this.onTap});

  final IconData iconData;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {

    //ClipRRect usado para dar o efeito do retangulo meio arrendondado
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      //InkWell da uma animação, poderia usar o gestodetector
      //para o InkWell funcionar preciar estar dentro de um widget Mareial
      child: Material(
        color: Colors.transparent, //deixa a cor do material transparente
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Icon(
              iconData,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
