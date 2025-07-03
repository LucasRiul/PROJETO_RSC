import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/view/TelaPrincipal/Dashboard/dashboard.dart';
import 'package:flutter_auth/Screens/view/TelaPrincipal/Conteudo/conteudo.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/controller/login_controller.dart';
import 'package:flutter_auth/controller/movimentacao_controller.dart';
import 'package:flutter_auth/model/movimentacao.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'Movimentações/movimentacoes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({Key? key}) : super(key: key);

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  var paginaAtual = 0;
  var nomeUpdate = TextEditingController();
  var paginaControlador = PageController();

  // GlobalKeys para os ícones da BottomNavigationBar
  final GlobalKey _dashboardKey = GlobalKey();
  final GlobalKey _movimentacoesKey = GlobalKey();
  final GlobalKey _conteudoKey = GlobalKey();

  // Tutorial coach mark
  List<TargetFocus> targets = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initTargets(); // Inicializa os focos do tour
      _checkTutorialShown();
    });
  }

  void _checkTutorialShown() async {
    bool primeiroacesso = await LoginController().getPrimeiroAcesso(context);

    if (primeiroacesso) {
      _showTutorial();
      // Marcar o tutorial como já exibido
      LoginController().acessou(context);
    }
  }

  // Configuração dos focos do tutorial
  void _initTargets() {
    targets.addAll([
      TargetFocus(
        identify: "Dashboard",
        keyTarget: _dashboardKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Text(
              "As movimentações de gastos e ganhos que você adicionar aparecerão aqui na dashboard para você analisar!\n A aba de Gastos mostra seus gastos do período selecionado agrupados por categoria.\n A aba de Ganhos mostra seus ganhos do período selecionado agrupados por categoria.\n A aba de Total mostra um balanço entre a diferença de Ganhos e Gastos do período selecionado.",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "Movimentações",
        keyTarget: _movimentacoesKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Text(
              "Aqui você pode adicionar, excluir, alterar e visualizar todas as suas movimentações de gastos e ganhos!",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "Conteúdos",
        keyTarget: _conteudoKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Text(
              "Aqui você pode acessar conteúdos informativos para te auxiliar na sua vida financeira!",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    ]);
  }

  // Função para exibir o tutorial
  void _showTutorial() {
    TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      textSkip: "Pular",
      paddingFocus: 10,
      opacityShadow: 0.8,
    ).show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              color: Colors.white,
              icon: const Icon(
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
      body: PageView(
        controller: paginaControlador,
        children: const [
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blueGrey.shade50,
        selectedItemColor: kPrimaryColor,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        currentIndex: paginaAtual,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bar_chart_rounded,
              color: kPrimaryColor,
              key: _dashboardKey, // Adicione a chave para o foco
            ),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.compare_arrows_outlined,
              color: kPrimaryColor,
              key: _movimentacoesKey, // Adicione a chave para o foco
            ),
            label: "Movimentações",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.book_outlined,
              color: kPrimaryColor,
              key: _conteudoKey, // Adicione a chave para o foco
            ),
            label: "Conteúdos",
          ),
        ],
        onTap: (index) {
          setState(() {
            paginaAtual = index;
          });
          paginaControlador.animateToPage(
            index,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
          );
        },
      ),
    );
  }
}
