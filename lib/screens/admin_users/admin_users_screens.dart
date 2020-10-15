import 'package:flutter/material.dart';
import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:lojavirtual/common/custom_drawer/custom_drawer.dart';
import 'package:lojavirtual/models/admin_users_manager.dart';
import 'package:provider/provider.dart';
class AdminUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Usuário'),
        centerTitle: true,
      ),
      body: Consumer<AdminUsersManager>(
        builder: (_, adminUserManager, __){
          return AlphabetListScrollView(
            itemBuilder: (_, index){
              return ListTile(
                title: Text(
                    adminUserManager.users[index].name,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white
                  ),
                ),
                subtitle: Text(
                  adminUserManager.users[index].email,
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              );
            },
            highlightTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20
            ),
            indexedHeight: (index) => 80, //controla o tamanho da letra selecionada
            strList: adminUserManager.names, //precisa passar lara o AlphabetListScrollView todos os nomes
            showPreview: true,
          );
        },
      ),
    );
  }
}
