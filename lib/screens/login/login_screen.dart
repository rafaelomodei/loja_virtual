import 'package:flutter/material.dart';
import 'package:lojavirtual/helpers/validators.dart';
import 'package:lojavirtual/models/user.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {

  //criar um text controller para pegar email e senha
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>(); //cria uma key para os validadores
  final GlobalKey<ScaffoldState> scaffalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffalKey,
      appBar: AppBar(
        title: const Text('Entrar'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton( //vai para tela de cadastro
            onPressed: (){
              Navigator.of(context).pushReplacementNamed('/signup'); // pushReplacementNamed vai subistituir a tela de logim pela tela de cadastro
            },
            child: const Text(
                'Criar conta',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form( //para acionar os validadores
            key: formKey,
            child: Consumer<UserManager>( //Consumer usado para colocar o loadin, ele fica observando <UserManager> se teve alteração e constroi/build o que esta dentro dele, atualizando as informação na tela do user
              builder: (_, userManager, child){ //o primeiro parametro é o contrex e nos não vamos usar(objeto), segundo é o user, terceiro child aqui foi usado de exemplo, mas é comum em fulhos grandes, que consome muitos processos e que não sofrem alterações
                return ListView( //define uma listview por causa se abrir o teclado não dar eto de estouro de tela
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: <Widget>[
                    TextFormField(
                      controller: emailController,
                      enabled: !userManager.loading, //bloquei ou não o campo de digitar
                      decoration: const InputDecoration(hintText: 'E-mail'),
                      keyboardType: TextInputType.emailAddress, //para colocar o @ no teclado
                      autocorrect: false, //desabilitar o corretor
                      validator: (email){
                        if(!emailValid(email)) // valida o email
                          return 'E-mail invalido ';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16,), //da um espaçamento entre um campo e outro
                    TextFormField(
                      controller: passController,
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(hintText: 'Senha'),
                      autocorrect: false,
                      obscureText: true,
                      validator: (pass){
                        if(pass.isEmpty || pass.length < 6)
                          return 'Senha inválida';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16,), //da um espaçamento entre um campo e outro
                    child,
                    SizedBox( //para deixar o bottão mais alto
                      height: 44,
                      child: RaisedButton(
                        onPressed: userManager.loading ? null : (){
                          if(formKey.currentState.validate()){ //ao clicar no botão, chama o validador
                            print(emailController.text);
                            userManager.signIn( //usa o provider para pegar o userManager e recebe o usuário pelo parametro
                                user: User(
                                    email: emailController.text,
                                    password: passController.text
                                ),
                                onFail: (e){
                                  scaffalKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text('Falha ao entrar: $e'),
                                        backgroundColor: Colors.red,
                                      )
                                  );
                                },
                                onSuccess: (){
                                  print('Sucesso');
                                  Navigator.of(context).pop(); //remove a tela de login
                                }
                            );
                          }
                        },
                        color: Theme.of(context).primaryColor,
                        disabledColor: Theme.of(context).primaryColor.withAlpha(700),
                        child: userManager.loading ?
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                            :const Text(
                          'Entrar',
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
              child: Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  onPressed: (){
                    formKey.currentState.validate(); //ao clicar no botão, chama o validador
                  },
                  padding: EdgeInsets.zero,
                  child: const Text(
                      'Esqueciminha senha'
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
