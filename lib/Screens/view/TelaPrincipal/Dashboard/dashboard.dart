import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_auth/Screens/view/TelaPrincipal/Dashboard/listaMovimentacoes.dart';
import 'package:flutter_auth/constants.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class LinearSales {
  final String mes;
  final int gasto;
  final int ganho;

  LinearSales(this.mes, this.ganho, this.gasto);
}

class _DashboardState extends State<Dashboard> {
  late List<charts.Series<LinearSales, String>> seriesList;

  final data = [
    LinearSales("Jan", 3000, 2800),
    LinearSales("Jan", 3000, 2800),
    LinearSales("Fev", 3000, 2800),
    LinearSales("Fev", 3000, 2500),
    LinearSales("Mar", 3000, 2500),
    LinearSales("Mar", 3000, 2500),
    LinearSales("Abr", 3000, 2200),
    LinearSales("Abr", 3000, 1900),
    LinearSales("Mai", 3000, 1900),
    LinearSales("Mai", 3000, 1900),
    LinearSales("Jun", 3500, 2200),
    LinearSales("Jun", 3500, 2200),
    LinearSales("Jul", 3500, 2100),
    LinearSales("Jul", 3400, 2100),
    LinearSales("Ago", 3400, 2100),
    LinearSales("Ago", 3400, 2200),
    LinearSales("Set", 3400, 2200),
    LinearSales("Set", 3000, 2300),
    LinearSales("Out", 3900, 2300),
    LinearSales("Out", 3900, 2300),
    LinearSales("Nov", 3900, 2200),
    LinearSales("Nov", 3000, 2200),
    LinearSales("Dez", 3000, 2200),
    LinearSales("Dez", 3000, 2200),
  ];

  @override
  void initState() {
    super.initState();
    seriesList = [
      charts.Series<LinearSales, String>(
        id: 'Earnings',
        domainFn: (LinearSales sales, _) => sales.mes,
        measureFn: (LinearSales sales, _) => sales.ganho,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        data: data,
      ),
      charts.Series<LinearSales, String>(
        id: 'Expenses',
        domainFn: (LinearSales sales, _) => sales.mes,
        measureFn: (LinearSales sales, _) => sales.gasto,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        data: data,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Row(
                children: [
                  Text(
                    'Movimentações do ano',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Tooltip(
                    message: 'Verde: Ganhos\nVermelho: Gastos',
                    child: Icon(Icons.info),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center),
            Expanded(
              child: Center(
                child: charts.BarChart(
                  seriesList,
                  animate: true,
                  behaviors: [
                    charts.ChartTitle(
                      'Meses',
                      behaviorPosition: charts.BehaviorPosition.bottom,
                      titleOutsideJustification:
                          charts.OutsideJustification.middleDrawArea,
                      innerPadding: 10,
                    ),
                    charts.ChartTitle(
                      "Valor R\$",
                      behaviorPosition: charts.BehaviorPosition.start,
                      titleOutsideJustification:
                          charts.OutsideJustification.middleDrawArea,
                      titleStyleSpec: charts.TextStyleSpec(fontSize: 14),
                    ),
                    // charts.SeriesLegend(
                    //   position: charts.BehaviorPosition.end,
                    //   horizontalFirst: false,
                    //   desiredMaxRows: 10,
                    //   cellPadding: EdgeInsets.only(right: 2.0, bottom: 4.0),
                    // ),
                  ],
                ),
              ),
            ),
            // Row(
            //   children: [
            //     ListaMovimentacoes(),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
