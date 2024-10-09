// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/view/TelaPrincipal/Dashboard/dashboard.dart';
import 'package:flutter_auth/Screens/view/TelaPrincipal/Conteudo/conteudo.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_auth/controller/login_controller.dart';
import 'package:flutter_auth/controller/movimentacao_controller.dart';
import 'package:flutter_auth/model/movimentacao.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Adicionar/adicionar.dart';
import 'Movimentações/movimentacoes.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({Key? key}) : super(key: key);

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  //Índice da página que está sendo exibida
  var paginaAtual = 0;
  var nomeUpdate = TextEditingController();
  
  //Responsável pela alteração (navegação) entre as páginas
  var paginaControlador = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Row(children: [
      //     Image.asset(
      //       'assets/images/LogoRSC.png',
      //       fit: BoxFit.contain,
      //       height: 80,
      //     )
      //   ]),
      //   backgroundColor: kPrimaryColor,
      //   automaticallyImplyLeading: false,
      // ),
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/LogoRSC.png',
              fit: BoxFit.contain,
              height: 90,
            ),
            IconButton(
              icon: Icon(
                Icons.exit_to_app_outlined,
                size: 25,
              ),
              onPressed: () {
                LoginController().logout();
                Navigator.pushReplacementNamed(context, 'inicio');
              },
            ),
          ],
        ),
      ),
      //CORPO
      body: PageView(
        controller: paginaControlador,
        children: [
          Dashboard(),
          Movimentacoes(),
          Conteudo(),
        ],
        onPageChanged: (index) {
          setState(() {
            paginaAtual = index;
          });
        },
      ),
      //BARRA DE NAVEGAÇÃO
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blueGrey.shade50,
        selectedItemColor: kPrimaryColor,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        //Página atual
        currentIndex: paginaAtual,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.bar_chart_rounded,
                color: kPrimaryColor,
              ),
              label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.compare_arrows_outlined,
                color: kPrimaryColor,
              ),
              label: "Movimentações"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.book_outlined,
                color: kPrimaryColor,
              ),
              label: "Conteúdo"),
        ],
        //TROCA DE PÁGINA
        onTap: (index) {
          setState(() {
            paginaAtual = index;
          });
          paginaControlador.animateToPage(
            index,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeIn,
          );
        },
      ),
    );
  }
}
