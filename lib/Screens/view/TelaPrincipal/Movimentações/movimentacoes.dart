import 'dart:js_interop';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/controller/movimentacao_controller.dart';
import 'package:flutter_auth/model/movimentacao.dart';
import '../../../../constants.dart';
import '../../../../controller/login_controller.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:easy_mask/easy_mask.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../util.dart' as util;
import 'package:intl/intl.dart'; // Para pegar o mês e ano atual

class Movimentacoes extends StatefulWidget {
  const Movimentacoes({super.key});

  @override
  State<Movimentacoes> createState() => _MovimentacoesState();
}

class _MovimentacoesState extends State<Movimentacoes> {
  var txtTitulo = TextEditingController();
  var txtDescricao = TextEditingController();

  String txtTipoMovimentacao = '';
  var valor = TextEditingController();
  var data = TextEditingController();
  var descricao = TextEditingController();

  // Lista de categorias
  List<dynamic> categorias = [];
  String? categoriaSelecionada;

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
    futureMovimentacoes =
        MovimentacaoController().listarComFiltro(selectedMonth, selectedYear);

    carregarCategorias(); // Carregar categorias uma vez no início
  }

  void _atualizarFiltro() {
    setState(() {
      futureMovimentacoes =
          MovimentacaoController().listarComFiltro(selectedMonth, selectedYear);
    });
  }

  // Carregar dados do JSON
  carregarCategorias() async {
    try {
      final String response =
          await rootBundle.loadString('lib/data/categorias.json');
      final data = json.decode(response);
      setState(() {
        categorias = data;
      });
    } catch (e) {
      print("Erro ao carregar categorias: $e"); // Exibe o erro no console
    }
  }

  IconData _mapIcon(String iconName) {
    // Mapeamento dos nomes dos ícones para os ícones reais do Flutter
    switch (iconName) {
      case "house_outlined":
        return Icons.house_outlined;
      case "account_balance_wallet_outlined":
        return Icons.account_balance_wallet_outlined;
      case "directions_car_outlined":
        return Icons.directions_car_outlined;
      case "restaurant_outlined":
        return Icons.restaurant_outlined;
      case "shopping_cart_outlined":
        return Icons.shopping_cart_outlined;
      case "wallet_giftcard_outlined":
        return Icons.wallet_giftcard_outlined;
      case "currency_exchange_outlined":
        return Icons.currency_exchange_outlined;
      case "book_outlined":
        return Icons.book_outlined;
      case "healing_outlined":
        return Icons.healing_outlined;
      case "business_outlined":
        return Icons.business_outlined;
      case "space_dashboard_outlined":
        return Icons.space_dashboard_outlined;
      default:
        return Icons.category_outlined; // Ícone padrão
    }
  }

  String validarFormulario(
      String? desc, String? cat, String? dt, String? vl, String? tipMv) {
    String msg = '';
    if (desc == '' || desc == null) {
      if (msg == '') {
        msg += 'Campo Descrição obrigatório.';
      } else {
        msg += '\nCampo Descrição obrigatório.';
      }
    }
    if (cat == '' || cat == null) {
      if (msg == '') {
        msg += 'Campo Categoria obrigatório.';
      } else {
        msg += '\nCampo Categoria obrigatório.';
      }
    }
    if (dt == '' || dt == null) {
      if (msg == '') {
        msg += 'Campo Data obrigatório.';
      } else {
        msg += '\nCampo Data obrigatório.';
      }
    }
    if (vl == '' || vl == null) {
      if (msg == '') {
        msg += 'Campo Valor obrigatório.';
      } else {
        msg += '\nCampo Valor obrigatório.';
      }
    }
    if (tipMv == '' || tipMv == null) {
      if (msg == '') {
        msg += 'Selecione Gasto ou Ganho.';
      } else {
        msg += '\nSelecione Gasto ou Ganho.';
      }
    }
    if (!validarData(dt)) {
      if (msg == '') {
        msg += 'Data inválida.';
      } else {
        msg += '\nData inválida.';
      }
    }

    return msg;
  }

  bool validarData(String? valor) {
    if (valor != null) {
      final partes = valor.split('/');
      if (partes.length == 3) {
        int? dia = int.tryParse(partes[0]);
        int? mes = int.tryParse(partes[1]);
        int? ano = int.tryParse(partes[2]);

        if (mes == null || mes < 1 || mes > 12) {
          return false;
        } else if (dia == null || dia < 1 || dia > 31) {
          return false;
        } else {
          return true;
        }
      } else {
        return false;
      }
    }
    return false;
  }

  void adicionarMovimentacao(context, {docId, dynamic movimentacao}) {
    if (movimentacao != null) {
      // Se for edição, preencher os campos com os dados existentes
      txtTipoMovimentacao = movimentacao['tipo'];
      valor.text = "R\$ " + movimentacao['valor'].toString();
      data.text = movimentacao['data'].toString();
      descricao.text = movimentacao['descricao'].toString();
      categoriaSelecionada = movimentacao['categoria'].toString();
    } else {
      var hoje = DateTime.now();
      data.text = '${hoje.day}/${hoje.month}/${hoje.year}';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder(
          future: carregarCategorias(), // Carrega as categorias
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return AlertDialog(
                title: Text("Erro ao carregar categorias"),
                content: Text("Ocorreu um erro ao carregar as categorias."),
              );
            } else {
              return AlertDialog(
                title: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child:
                          docId == null ? Text("Adicionar") : Text("Alterar"),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          txtTipoMovimentacao = '';
                          valor.clear();
                          data.clear();
                          descricao.clear();
                          categoriaSelecionada = categorias.isNotEmpty
                              ? categorias[0]['Nome']
                              : ''; // Reseta a categoria;
                          Navigator.of(context).pop(); // Fecha o diálogo
                        },
                      ),
                    ),
                  ],
                ),
                content: SingleChildScrollView(
                  child: SizedBox(
                    height: 300,
                    width: 350,
                    child: Column(
                      children: [
                        CustomRadioButton(
                          elevation: 2,
                          enableShape: true,
                          shapeRadius: 20,
                          absoluteZeroSpacing: true,
                          defaultSelected: txtTipoMovimentacao.isNotEmpty
                              ? txtTipoMovimentacao
                              : null,
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          padding: 10,
                          spacing: 30,
                          unSelectedColor: Colors.white,
                          buttonLables: [
                            'Gasto',
                            'Ganho',
                          ],
                          buttonValues: [
                            "GASTO",
                            "GANHO",
                          ],
                          buttonTextStyle: ButtonTextStyle(
                              selectedColor: Colors.white,
                              unSelectedColor: Colors.black,
                              textStyle: TextStyle(fontSize: 16)),
                          radioButtonValue: (value) {
                            txtTipoMovimentacao = value.toString();
                          },
                          selectedColor: kPrimaryColor,
                        ),
                        Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 10)),
                        TextField(
                          controller: valor,
                          inputFormatters: [
                            TextInputMask(
                                mask: 'R!\$! !9+,99',
                                placeholder: '0',
                                maxPlaceHolders: 3,
                                reverse: true)
                          ],
                          decoration: InputDecoration(
                            labelText: 'Valor(R\$)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 10)),
                        TextField(
                          controller: data,
                          inputFormatters: [
                            TextInputMask(mask: '99/99/9999', reverse: false)
                          ],
                          decoration: InputDecoration(
                            labelText: 'Data',
                            hintText: 'dd/mm/aaaa',
                            prefixIcon: Icon(Icons.date_range),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 10)),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          alignment: Alignment.center,
                          decoration: InputDecoration(
                            labelText: 'Categoria',
                            border: OutlineInputBorder(),
                          ),
                          value: categoriaSelecionada,
                          items: categorias
                              .map<DropdownMenuItem<String>>((categoria) {
                            return DropdownMenuItem<String>(
                              value: categoria['Nome'],
                              child: Row(
                                children: [
                                  Icon(
                                    _mapIcon(categoria['Icone']),
                                    color: Color(int.parse(
                                        '0xff${categoria['Cor'].substring(1)}')),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    categoria['Nome'],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              categoriaSelecionada = value;
                            });
                          },
                        ),
                        Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 10)),
                        TextField(
                          controller: descricao,
                          decoration: InputDecoration(
                            labelText: 'Descrição',
                            prefixIcon: Icon(Icons.edit),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actionsPadding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                actions: [
                  ElevatedButton(
                    child: Text(
                      "salvar",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      var erro = validarFormulario(
                          descricao.text,
                          categoriaSelecionada,
                          data.text,
                          valor.text,
                          txtTipoMovimentacao);
                      var dataSplit = data.text.split('/');
                      if (erro == '') {
                        var mes = dataSplit[1];
                        var ano = dataSplit[2];
                        var t = Movimentacao(
                          LoginController().idUsuario(),
                          txtTipoMovimentacao,
                          valor.text.split(' ')[1],
                          data.text,
                          mes,
                          ano,
                          descricao.text,
                          categoriaSelecionada.toString(),
                        );
                        txtTipoMovimentacao = '';
                        valor.clear();
                        data.clear();
                        descricao.clear();
                        categoriaSelecionada = categorias.isNotEmpty
                            ? categorias[0]['Nome']
                            : ''; // Reseta a categoria

                        if (docId == null) {
                          MovimentacaoController().adicionar(context, t);
                        } else {
                          MovimentacaoController().atualizar(context, docId, t);
                        }
                        Navigator.of(context).pop(); // Fecha o diálogo
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Formulário Inválido"),
                                  ),
                                ],
                              ),
                              content: Text(erro),
                              actions: [
                                ElevatedButton(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.red, // Cor do botão de exclusão
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Fecha o diálogo após a exclusão
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  void confirmarExclusao(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Confirmar exclusão"),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop(); // Fecha o diálogo
                  },
                ),
              ),
            ],
          ),
          content: Text("Tem certeza que deseja excluir esta movimentação?"),
          actions: [
            ElevatedButton(
              child: Text(
                "Excluir",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Cor do botão de exclusão
              ),
              onPressed: () {
                // Função para excluir a movimentação
                MovimentacaoController().excluir(context, docId);
                Navigator.of(context).pop(); // Fecha o diálogo após a exclusão
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
                const SizedBox(width: 10),
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
                  icon: const Icon(Icons.search),
                  onPressed: _atualizarFiltro, // Atualiza a lista ao clicar
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: futureMovimentacoes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Center(
                        child: Text('Não foi possível conectar.'),
                      );
                    case ConnectionState.waiting:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      final dados = snapshot.data!;
                      if (snapshot.hasError) {
                        return Center(child: Text('Erro: ${snapshot.error}'));
                      }
                      if (dados.isNotEmpty) {
                        return ListView.builder(
                          itemCount: dados.length,
                          itemBuilder: (context, index) {
                            // String id = dados.docs[index].id;
                            dynamic item = dados[index];
                            return Card(
                              child: ListTile(
                                leading: item['tipo'] == "GASTO"
                                    ? Icon(Icons.keyboard_double_arrow_down,
                                        color: Colors.red)
                                    : Icon(Icons.keyboard_double_arrow_up,
                                        color: Colors.green),
                                title: Text(
                                  'R\$' +
                                      item['valor'].toString() +
                                      ' - ' +
                                      item['categoria'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 17),
                                ),
                                subtitle: Text(item['descricao'],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 17)),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete,
                                      color: Color.fromARGB(255, 247, 99, 89)),
                                  onPressed: () {
                                    confirmarExclusao(
                                        context,
                                        item[
                                            'docId']); // Função para confirmar a exclusão
                                  },
                                ),
                                onTap: () {
                                  txtTitulo.text = item['categoria'];
                                  txtDescricao.text = item['descricao'];

                                  adicionarMovimentacao(context,
                                      docId: item['docId'], movimentacao: item);
                                },
                                onLongPress: () {
                                  MovimentacaoController()
                                      .excluir(context, item['docId']);
                                },
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Text(
                            'Você ainda não cadastrou nenhuma movimentação. \nClique no "+" para adicionar um gasto ou um ganho.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          adicionarMovimentacao(context);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: kPrimaryColor,
      ),
    );
  }
}
