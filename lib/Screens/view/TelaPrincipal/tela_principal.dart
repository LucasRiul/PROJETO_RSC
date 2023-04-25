// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/view/TelaPrincipal/Dashboard/dashboard.dart';
import 'package:flutter_auth/Screens/view/TelaPrincipal/Conteudo/conteudo.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({Key? key}) : super(key: key);

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  //Índice da página que está sendo exibida
  var paginaAtual = 0;
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
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 30,
                  ),
                  Text(
                    "usuarioLogado",
                    style: GoogleFonts.raleway(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Image.asset(
              'assets/images/LogoRSC.png',
              fit: BoxFit.contain,
              height: 90,
            ),
          ],
        ),
      ),
      //CORPO
      body: PageView(
        controller: paginaControlador,
        children: [
          Dashboard(),
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
