// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../model/conteudos.dart';

class WidgetConteudo extends StatefulWidget {
  const WidgetConteudo({super.key});

  @override
  State<WidgetConteudo> createState() => _WidgetConteudoState();
}

class _WidgetConteudoState extends State<WidgetConteudo> {
  @override
  Widget build(BuildContext context) {
    var obj = ModalRoute.of(context)!.settings.arguments as Conteudos;

    return Scaffold(
      appBar: AppBar(
        title: Text("RSC"),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(obj.tema,
                style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
            Text(obj.descricao,
                style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
            Text(obj.foto,
                style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
          ],
        ),
      ),
      //BOTÃO FLUTUANTE
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.keyboard_return),
        onPressed: () {
          //Voltar para TelaPrincipal
          Navigator.pop(context);
        },
      ),
    );
  }
}
