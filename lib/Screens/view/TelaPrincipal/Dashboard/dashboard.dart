import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/controller/login_controller.dart';
import 'package:flutter_auth/controller/movimentacao_controller.dart';
import 'package:intl/intl.dart'; // Para pegar o mês e ano atual
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  int _touchedIndex1 = 0;
  int _touchedIndex2 = 0;
  late TabController _tabController;

  String selectedMonth =
      DateFormat.MMMM('pt_BR').format(DateTime.now()).toLowerCase();
  String selectedYear = DateTime.now().year.toString(); // Ano atual
  Future<List<Map<String, dynamic>>>? futureMovimentacoes;

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
    futureMovimentacoes =
        MovimentacaoController().listarComFiltro(selectedMonth, selectedYear);
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        // Reinicialize os índices de toque ao trocar de aba
        setState(() {
          _touchedIndex1 = -1;
          _touchedIndex2 = -1;
        });
      }
    });
  }

  IconData _mapIcon(String iconName) {
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
      case "Renda fixa":
        return Icons.attach_money_outlined;
      case "Ganhos extras":
        return Icons.currency_exchange_outlined;
      default:
        return Icons.category_outlined; // Ícone padrão
    }
  }

  Color _mapColor(String categoria) {
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
        cor = "#f2d13f";
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
      case "Renda fixa":
        cor = "#63b063";
        break;
      case "Ganhos extras":
        cor = "#21825e";
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
      futureMovimentacoes =
          MovimentacaoController().listarComFiltro(selectedMonth, selectedYear);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: kPrimaryColor,
              indicatorColor: kPrimaryColor,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'Gastos'),
                Tab(text: 'Ganhos'),
                Tab(text: 'Total'),
              ],
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 20)),

            // Dropdowns para selecionar mês e ano
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedMonth,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMonth = newValue!;
                        _atualizarFiltro();
                      });
                    },
                    items: months.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child:
                            Text(value[0].toUpperCase() + value.substring(1)),
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
                        _atualizarFiltro();
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
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: futureMovimentacoes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar dados'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text(
                      'Você ainda não cadastrou nenhuma movimentação neste período.\n Vá para a página de "Movimentações" adicionar gastos e ganhos e depois retorne aqui.',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ));
                  } else {
                    var gastos = snapshot.data!
                        .where((mov) => mov['tipo'] == 'GASTO')
                        .toList();
                    var ganhos = snapshot.data!
                        .where((mov) => mov['tipo'] == 'GANHO')
                        .toList();

                    var categoriasGastos =
                        groupBy(gastos, (Map g) => g['categoria']);
                    var categoriasGanhos =
                        groupBy(ganhos, (Map g) => g['categoria']);

                    double totalGastos = gastos.fold(0, (sum, item) {
                      return sum +
                          double.parse(
                              item['valor'].toString().replaceAll(',', '.'));
                    });
                    double totalGanhos = ganhos.fold(0, (sum, item) {
                      return sum +
                          double.parse(
                              item['valor'].toString().replaceAll(',', '.'));
                    });

                    return TabBarView(
                      controller: _tabController,
                      children: [
                        // Tab de Gastos
                        Column(
                          children: [
                            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                            SizedBox(
                              height: 28,
                              child: Text(
                                "R\$ ${totalGastos.toStringAsFixed(2).replaceAll('.', ',')}",
                                style: TextStyle(
                                    color: Colors.red[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
                            ),
                            // Gráfico de Gastos
                            categoriasGastos.isNotEmpty
                                ? Expanded(
                                    flex: 2,
                                    child: PieChart(
                                      swapAnimationDuration:
                                          Duration(milliseconds: 150),
                                      swapAnimationCurve: Curves.linear,
                                      PieChartData(
                                        centerSpaceRadius: 65,
                                        pieTouchData:
                                            PieTouchData(touchCallback: (
                                          FlTouchEvent e,
                                          PieTouchResponse? r,
                                        ) {
                                          if (r != null &&
                                              r.touchedSection != null) {
                                            setState(() {
                                              _touchedIndex1 = r.touchedSection!
                                                  .touchedSectionIndex;
                                            });
                                          }
                                        }),
                                        sections: categoriasGastos.keys
                                            .mapIndexed((i, cat) {
                                          final isTouched = _touchedIndex1 == i;
                                          var total = categoriasGastos[cat]!
                                              .map((gasto) => double.parse(
                                                  gasto['valor']
                                                      .toString()
                                                      .replaceAll(',', '.')))
                                              .reduce((a, b) => a + b);
                                          final percentualCatgoria =
                                              ((total / totalGastos) * 100)
                                                      .toStringAsFixed(2)
                                                      .replaceAll('.', ',') +
                                                  "%";
                                          return PieChartSectionData(
                                            value: total,
                                            badgeWidget: !isTouched
                                                ? Icon(
                                                    _mapIcon(cat),
                                                    color: Colors.white,
                                                  )
                                                : null,
                                            title: isTouched
                                                ? percentualCatgoria
                                                : null,
                                            titleStyle: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                shadows: [
                                                  Shadow(
                                                      blurRadius: 50,
                                                      color: Colors.black,
                                                      offset:
                                                          Offset(-1.5, -1.5))
                                                ]),
                                            color: _mapColor(cat),
                                            showTitle: isTouched ? true : false,
                                            radius: isTouched ? 75 : 65,
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  )
                                : Text(''),

                            // Lista de categorias de Gastos
                            categoriasGastos.isNotEmpty
                                ? Expanded(
                                    child: ListView.builder(
                                      itemCount: categoriasGastos.length,
                                      itemBuilder: (context, index) {
                                        var categoria = categoriasGastos.keys
                                            .elementAt(index);
                                        var total = categoriasGastos[categoria]!
                                            .map((gasto) => double.parse(
                                                gasto['valor']
                                                    .toString()
                                                    .replaceAll(',', '.')))
                                            .reduce((a, b) => a + b);
                                        return Card(
                                          child: ListTile(
                                            leading: Icon(
                                              _mapIcon(categoria),
                                              color: _mapColor(categoria),
                                            ),
                                            title: Text(
                                              categoria,
                                              style: TextStyle(fontSize: 17),
                                            ),
                                            trailing: Text(
                                              'R\$ ${total.toStringAsFixed(2)}',
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Text(''),
                          ],
                        ),
                        // Tab de Ganhos
                        Column(
                          children: [
                            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                            SizedBox(
                              height: 28,
                              child: Text(
                                "R\$ ${totalGanhos.toStringAsFixed(2).replaceAll('.', ',')}",
                                style: TextStyle(
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
                            ),
                            // Gráfico de Ganhos
                            categoriasGanhos.isNotEmpty
                                ? Expanded(
                                    flex: 2,
                                    child: PieChart(
                                      swapAnimationDuration:
                                          Duration(milliseconds: 150),
                                      swapAnimationCurve: Curves.linear,
                                      PieChartData(
                                        centerSpaceRadius: 65,
                                        pieTouchData:
                                            PieTouchData(touchCallback: (
                                          FlTouchEvent e2,
                                          PieTouchResponse? r2,
                                        ) {
                                          if (r2 != null &&
                                              r2.touchedSection != null) {
                                            setState(() {
                                              _touchedIndex2 = r2
                                                  .touchedSection!
                                                  .touchedSectionIndex;
                                            });
                                          }
                                        }),
                                        sections: categoriasGanhos.keys
                                            .mapIndexed((i2, cat) {
                                          var total = categoriasGanhos[cat]!
                                              .map((ganho) => double.parse(
                                                  ganho['valor']
                                                      .toString()
                                                      .replaceAll(',', '.')))
                                              .reduce((a, b) => a + b);
                                          final isTouched2 =
                                              _touchedIndex2 == i2;
                                          final percentualCatgoria =
                                              ((total / totalGanhos) * 100)
                                                      .toStringAsFixed(2)
                                                      .replaceAll('.', ',') +
                                                  "%";
                                          return PieChartSectionData(
                                            value: total,
                                            badgeWidget: !isTouched2
                                                ? Icon(
                                                    _mapIcon(cat),
                                                    color: Colors.white,
                                                  )
                                                : null,
                                            title: isTouched2
                                                ? percentualCatgoria
                                                : null,
                                            titleStyle: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            color: _mapColor(cat),
                                            showTitle:
                                                isTouched2 ? true : false,
                                            radius: isTouched2 ? 75 : 65,
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  )
                                : Text(''),

                            // Lista de categorias de Ganhos
                            categoriasGanhos.isNotEmpty
                                ? Expanded(
                                    child: ListView.builder(
                                      itemCount: categoriasGanhos.length,
                                      itemBuilder: (context, index) {
                                        var categoria = categoriasGanhos.keys
                                            .elementAt(index);
                                        var total = categoriasGanhos[categoria]!
                                            .map((ganho) => double.parse(
                                                ganho['valor']
                                                    .toString()
                                                    .replaceAll(',', '.')))
                                            .reduce((a, b) => a + b);
                                        return Card(
                                          child: ListTile(
                                            leading: Icon(
                                              _mapIcon(categoria),
                                              color: _mapColor(categoria),
                                            ),
                                            title: Text(
                                              categoria,
                                              style: TextStyle(fontSize: 17),
                                            ),
                                            trailing: Text(
                                              'R\$ ${total.toStringAsFixed(2)}',
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Text(''),
                          ],
                        ),
                        // Tab do Totalizador
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Total $selectedMonth/$selectedYear",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Colors.black87),
                              ),
                              TweenAnimationBuilder(
                                tween: Tween<double>(
                                    begin: 0, end: (totalGanhos - totalGastos)),
                                duration: Duration(seconds: 2),
                                builder: (context, value, child) {
                                  return Text(
                                    ' R\$ ${double.parse(value.toString()).toStringAsFixed(2).replaceAll('.', ',')}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: (totalGanhos - totalGastos) > 0
                                            ? Colors.green[700]
                                            : Colors.red[700]),
                                  );
                                },
                              )
                            ]),
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
