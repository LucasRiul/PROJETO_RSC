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

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({Key? key}) : super(key: key);

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  //Índice da página que está sendo exibida
  var paginaAtual = 0;
  var nomeUpdate = TextEditingController();
  var txtTipoMovimentacao = TextEditingController();
  var valor = TextEditingController();
  var data = TextEditingController();
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
            FutureBuilder<String>(
              future: LoginController().usuarioLogado(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
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
                      IconButton(
                        icon: Icon(Icons.person, size: 25),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // retorna um objeto do tipo Dialog
                              return AlertDialog(
                                title: Text("Alterar nome"),
                                content: SizedBox(
                                  height: 150,
                                  width: 300,
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: nomeUpdate,
                                        decoration: InputDecoration(
                                          labelText: 'Nome',
                                          prefixIcon: Icon(Icons.person),
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actionsPadding:
                                    EdgeInsets.fromLTRB(20, 0, 20, 10),
                                actions: [
                                  TextButton(
                                    child: Text("fechar"),
                                    onPressed: () {
                                      nomeUpdate.clear();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ElevatedButton(
                                    child: Text("salvar"),
                                    onPressed: () {
                                      LoginController().alterarNome(
                                          context, nomeUpdate.text);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      Text(
                        snapshot.data?.toUpperCase() ??
                            '', // Acessa o valor retornado pela Future.
                        style: GoogleFonts.raleway(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
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
          Conteudo(),
        ],
        onPageChanged: (index) {
          setState(() {
            paginaAtual = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          adicionarMovimentacao(context);
        },
        child: Icon(Icons.add),
        backgroundColor: kPrimaryColor,
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

  void adicionarMovimentacao(context, {docId}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: Text("Adicionar Movimentação"),
          content: SizedBox(
            height: 250,
            width: 300,
            child: Column(
              children: [
                TextField(
                  controller: txtTipoMovimentacao,
                  decoration: InputDecoration(
                    labelText: 'Tipo Movimentação',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 10)),
                TextField(
                  controller: valor,
                  decoration: InputDecoration(
                    labelText: 'Valor(R\$)',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 10)),
                TextField(
                  controller: data,
                  decoration: InputDecoration(
                    labelText: 'Data',
                    prefixIcon: Icon(Icons.date_range),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          actions: [
            TextButton(
              child: Text("fechar"),
              onPressed: () {
                txtTipoMovimentacao.clear();
                valor.clear();
                data.clear();
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("salvar"),
              onPressed: () {
                var t = Movimentacao(LoginController().idUsuario(),
                    txtTipoMovimentacao.text, valor.text, data.text);
                txtTipoMovimentacao.clear();
                valor.clear();
                data.clear();
                if (docId == null) {
                  MovimentacaoController().adicionar(context, t);
                } else {
                  MovimentacaoController().atualizar(context, docId, t);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
