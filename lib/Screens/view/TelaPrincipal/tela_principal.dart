// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/view/TelaPrincipal/Dashboard/dashboard.dart';
import 'package:flutter_auth/Screens/view/TelaPrincipal/Conteudo/conteudo.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_auth/controller/login_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Adicionar/adicionar.dart';

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
              child: FutureBuilder<String>(
                future: LoginController().usuarioLogado(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Se ainda estiver carregando, exiba um widget de carregamento ou uma mensagem de espera.
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Se ocorrer um erro, exiba uma mensagem de erro.
                    return Text('Erro: ${snapshot.error}');
                  } else {
                    // Se tudo estiver correto, exiba o nome do usuário.
                    return Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 30,
                        ),
                        Text(
                          snapshot.data?.toUpperCase() ??
                              '', // Acessa o valor retornado pela Future.
                          style: GoogleFonts.raleway(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }
                },
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
          Adicionar(),
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
              Icons.add_circle_rounded,
              color: kPrimaryColor,
              size: 50,
            ),
            label: "",
          ),
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
