import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_auth/controller/login_controller.dart';
import 'package:intl/intl.dart'; // Para pegar o mês e ano atual
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String selectedMonth =
      DateFormat.MMMM('pt_BR').format(DateTime.now()).toLowerCase();
  String selectedYear = DateTime.now().year.toString(); // Ano atual
  Future<List<Map<String, dynamic>>>? futureGastos;

  List<String> months = [
    'janeiro',
    'fevereiro',
    'março',
    'abril',
    'maio',
    'junho',
    'julho',
    'agosto',
    'setembro',
    'outubro',
    'novembro',
    'dezembro'
  ];

  @override
  void initState() {
    super.initState();
    // Inicia o FutureBuilder com o mês e ano atuais
    futureGastos = listarComFiltro(selectedMonth, selectedYear);
  }

  Future<List<Map<String, dynamic>>> listarComFiltro(
      String mes, String ano) async {
    mes = _converterMes(mes);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('movimentacao')
        .where('uid',
            isEqualTo: LoginController()
                .idUsuario()) // Use o método correto para pegar o UID
        .where('mes', isEqualTo: mes)
        .where('ano', isEqualTo: ano)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return []; // Retorna uma lista vazia se não houver dados
    } else {
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    }
  }

  IconData _mapIcon(String iconName) {
    // Mapeamento dos nomes dos ícones para os ícones reais do Flutter
    switch (iconName) {
      case "Casa":
        return Icons.house_outlined;
      case "Contas e serviços":
        return Icons.account_balance_wallet_outlined;
      case "Transporte":
        return Icons.directions_car_outlined;
      case "Comida e bebida":
        return Icons.restaurant_outlined;
      case "Supermercado":
        return Icons.shopping_cart_outlined;
      case "Compras":
        return Icons.wallet_giftcard_outlined;
      case "Financiamentos":
        return Icons.currency_exchange_outlined;
      case "Educação":
        return Icons.book_outlined;
      case "Saúde":
        return Icons.healing_outlined;
      case "Investimentos":
        return Icons.business_outlined;
      case "Outros":
        return Icons.space_dashboard_outlined;
      default:
        return Icons.category_outlined; // Ícone padrão
    }
  }

  Color _mapColor(String categoria) {
    // Mapeamento dos nomes dos ícones para os ícones reais do Flutter
    String cor;
    switch (categoria) {
      case "Casa":
        cor = "#41c7e8";
        break;
      case "Contas e serviços":
        cor = "#f27c41";
        break;
      case "Transporte":
        cor = "#4141f2";
        break;
      case "Comida e bebida":
        cor = "#f24141";
        break;
      case "Supermercado":
        cor = "#41f29a";
        break;
      case "Compras":
        cor = "#c941f2";
        break;
      case "Financiamentos":
        cor = "#ddf241";
        break;
      case "Educação":
        cor = "#41daf2";
        break;
      case "Saúde":
        cor = "#41f2da";
        break;
      case "Investimentos":
        cor = "#f2a241";
        break;
      case "Outros":
        cor = "#f241c6";
        break;
      default:
        cor = "#f0f0f0";
        break;
    }

    return Color(int.parse('0xff${cor.substring(1)}'));
  }

  // Atualiza o filtro ao clicar no ícone de pesquisa
  void _atualizarFiltro() {
    setState(() {
      futureGastos = listarComFiltro(selectedMonth, selectedYear);
    });
  }

  _converterMes(mes) {
    mes = mes.toString().toLowerCase();
    if (mes == 'janeiro') return '01';
    if (mes == 'fevereiro') return '02';
    if (mes == 'março') return '03';
    if (mes == 'abril') return '04';
    if (mes == 'maio') return '05';
    if (mes == 'junho') return '06';
    if (mes == 'julho') return '07';
    if (mes == 'agosto') return '08';
    if (mes == 'setembro') return '09';
    if (mes == 'outubro') return '10';
    if (mes == 'novembro') return '11';
    if (mes == 'dezembro') return '12';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdowns para selecionar mês e ano
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedMonth,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMonth = newValue!;
                      });
                    },
                    items: months.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value[0].toUpperCase() +
                            value.substring(1)), // Capitaliza a primeira letra
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedYear,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedYear = newValue!;
                      });
                    },
                    items: List<String>.generate(4, (index) {
                      int year = DateTime.now().year - index;
                      return year.toString();
                    }).map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _atualizarFiltro, // Atualiza a lista ao clicar
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: futureGastos,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar dados'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Não há dados para exibir'));
                  } else {
                    var categorias =
                        groupBy(snapshot.data!, (Map g) => g['categoria']);

                    List<PieChartSectionData> listaGrafico = [];
                    for (var i = 0; i < categorias.length; i++) {
                      var cat = categorias.keys.elementAt(i);
                      var tot = categorias[cat]!
                          .map((gasto) => double.parse(
                              gasto['valor'].toString().replaceAll(',', '.')))
                          .reduce((a, b) => a + b);
                      listaGrafico.add(PieChartSectionData(
                          value: tot,
                          title: cat,
                          titleStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: Offset(-1.5, -1.5),
                                color: Colors.white,
                              )
                            ],
                          ),
                          radius: 70,
                          showTitle: true,
                          color: _mapColor(cat)));
                    }

                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 300,
                              height: 400,
                              child: (PieChart(
                                swapAnimationCurve: Curves.decelerate,
                                swapAnimationDuration: Duration(seconds: 2),
                                PieChartData(
                                  sections: listaGrafico,
                                ),
                              )),
                            ),
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: categorias.length,
                            itemBuilder: (context, index) {
                              var categoria = categorias.keys.elementAt(index);
                              var total = categorias[categoria]!
                                  .map((gasto) => double.parse(gasto['valor']
                                      .toString()
                                      .replaceAll(',', '.')))
                                  .reduce((a, b) => a + b);

                              return Card(
                                child: ListTile(
                                  leading: Icon(
                                    _mapIcon(categoria),
                                    color: _mapColor(categoria),
                                  ),
                                  title: Text(categoria),
                                  trailing:
                                      Text('R\$ ${total.toStringAsFixed(2)}'),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
