// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../model/conteudos.dart';

class Conteudo extends StatefulWidget {
  const Conteudo({super.key});

  @override
  State<Conteudo> createState() => ConteudoState();
}

class ConteudoState extends State<Conteudo> {
  //Lista dinâmica de objetos da classe PAIS
  List<Conteudos> dados = [];

  //Carregar os dados do arquivo JSON
  carregarDados() async {
    final String arquivo =
        await rootBundle.loadString('lib/data/conteudos.json');
    final dynamic lista = await json.decode(arquivo);
    setState(() {
      lista.forEach((item) {
        dados.add(Conteudos.fromJson(item));
      });
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await carregarDados();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: dados.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(dados[index].tema),
                onTap: () {
                  //NAVEGAR para TelaDetalhes
                  var obj = dados[index];
                  Navigator.pushNamed(
                    context,
                    'conteudos',
                    arguments: obj,
                  );
                },
              ),
            );
          }),
    );
  }
}
