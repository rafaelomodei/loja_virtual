import 'package:flutter/material.dart';
import 'package:lojavirtual/helpers/validators.dart';
import 'package:lojavirtual/models/user.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final User user = User(); //inicia com o usuário vazio
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Criar conta'),
        centerTitle: true, //centraliza o testo na tela
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formkey,
            child: Consumer<UserManager>(
              builder: (_, userManager,__) {
               return ListView(
                 padding: const EdgeInsets.all(16),
                 shrinkWrap: true, //para deixar a listviw menor possivel
                 children: <Widget>[
                   TextFormField(
                     decoration: const InputDecoration(hintText: 'Nome Completo'),
                     enabled: !userManager.loading,
                     validator: (name){
                       if(name.isEmpty){
                         return 'Campo obrigatório';
                       }else if(name.trim().split(' ').length <= 1){
                         return 'Preencha seu Nome Completo';
                       }
                       return null;
                     },
                     onSaved: (name) => user.name = name,
                   ),
                   const SizedBox(height: 16,), //deixa um espaçamento
                   TextFormField(
                     decoration: const InputDecoration(hintText: 'E-mail'),
                     enabled: !userManager.loading,
                     keyboardType: TextInputType.emailAddress, //coloca o @ no teclado
                     validator: (email){
                       if(email.isEmpty){
                         return 'Campo obrigatório';
                       }else if(!emailValid(email)){
                         return 'E-mail inválido';
                       }
                       return null;
                     },
                     onSaved: (email) => user.email = email, //pega o email digitado pelo user e joga no campo email
                   ),
                   const SizedBox(height: 16,),
                   TextFormField(
                     decoration: const InputDecoration(hintText: 'Senha'),
                     enabled: !userManager.loading,
                     obscureText: true, //deixa a senha oculta
                     validator: (pass){
                       if(pass.isEmpty){
                         return 'Campo obrigatório';
                       }else if(pass.length < 8){
                         return 'Senha muito fraca';
                       }
                       return null;
                     },
                     onSaved: (pass) => user.password = pass, //o mesmo que rola no e-mail
                   ),
                   const SizedBox(height: 16,),
                   TextFormField(
                     decoration: const InputDecoration(hintText: 'Repita a senha'),
                     enabled: !userManager.loading,
                     obscureText: true,
                     validator: (pass){
                       if(pass.isEmpty){
                         return 'Campo obrigatório';
                       }else if(pass.length < 8){
                         return 'Senha muito fraca';
                       }
                       return null;
                     },
                     onSaved: (pass) => user.confirmPassword = pass,
                   ),
                   const SizedBox(height: 16,),
                   SizedBox(
                     height: 44, //altura do botão
                     child: RaisedButton(
                       color: Theme.of(context).primaryColor,
                       disabledColor: Theme.of(context).primaryColor.withAlpha(700),
                       textColor: Colors.white,
                       onPressed: userManager.loading ? null : (){
                         if(formkey.currentState.validate()){
                           formkey.currentState.save(); // o metodo save vai chamar o metodo onSaved, chamando de todos os TextFormField
                           if(user.password != user.confirmPassword){
                             //SnackBar para alerta o usuário que a senha não coincidem
                             //scaffoldKey é o cara que faz toda magica para aparecer na tela do user
                             scaffoldKey.currentState.showSnackBar(
                                 SnackBar(
                                   content: const Text(
                                     'Senhas não coincidem',
                                   ),
                                   backgroundColor: Colors.red,
                                 )
                             );
                             return;
                           }
                           //usermanager
                           userManager.sinUp(
                               user: user,
                               onSuccess: (){
                                 debugPrint('Sucesso');
                                 Navigator.of(context).pop();//remove a tela de cadastro
                               },
                               onFail: (e){
                                 scaffoldKey.currentState.showSnackBar(
                                   SnackBar(
                                     content: Text('Falha ao Cadastrar $e'),
                                     backgroundColor: Colors.red,
                                   ),
                                 );
                               }
                           );
                         }
                       },
                       child: userManager.loading ? 
                       CircularProgressIndicator(
                         valueColor: AlwaysStoppedAnimation(Colors.white),
                       )
                       : const Text(
                         'Ciar Conta',
                         style: TextStyle(
                             color: Colors.white,
                             fontSize: 18
                         ),
                       ),
                     ),
                   )
                 ],
               );
              },
            ),
          ),
        ),
      ),
    );
  }
}
