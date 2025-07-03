// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../model/conteudos.dart';
import 'package:google_fonts/google_fonts.dart';

class WidgetConteudo extends StatefulWidget {
  const WidgetConteudo({super.key});

  @override
  State<WidgetConteudo> createState() => _WidgetConteudoState();
}

class _WidgetConteudoState extends State<WidgetConteudo> {
  @override
  Widget build(BuildContext context) {
    var obj = ModalRoute.of(context)!.settings.arguments as Conteudos;
    var txtVideo = obj.videoLink != "a" ? "Video sugerido" : "";
    var htmlData =
        '<iframe width="560" height="315" src="${obj.videoLink}" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/images/LogoRSC.png',
              fit: BoxFit.contain,
              height: 90,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: defaultPadding * 3),
            Text(obj.tema,
                style: GoogleFonts.raleway(
                    fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            SizedBox(height: defaultPadding * 3),
            Text(obj.descricao,
                style: GoogleFonts.raleway(fontSize: 20),
                textAlign: TextAlign.center),
            SizedBox(height: defaultPadding * 3),
            AspectRatio(
              aspectRatio: 4.0 / 3.0,
              child: Image.asset(
                obj.foto,
                scale: 1.0,
                fit: BoxFit.cover,
              ),
            ),
            Text(obj.fotoDescricao,
                style: GoogleFonts.raleway(fontSize: 16),
                textAlign: TextAlign.center),
            SizedBox(height: defaultPadding * 3),
            // HtmlWidget(htmlData),
            Text(
              txtVideo,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: defaultPadding * 10),
          ],
        ),
      ),
      //BOTÃO FLUTUANTE
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: Icon(
          Icons.keyboard_return,
          color: Colors.white,
        ),
        onPressed: () {
          //Voltar para TelaPrincipal
          Navigator.pop(context);
        },
      ),
    );
  }
}
