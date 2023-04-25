// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return Scaffold(
      // appBar: AppBar(
      //   title: Row(children: [
      //     Icon(
      //       Icons.person,
      //       size: 2,
      //     ),
      //     Text(
      //       "usuarioLogado",
      //       style:
      //           GoogleFonts.raleway(fontSize: 12, fontWeight: FontWeight.bold),
      //     ),
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
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 30,
                  ),
                  Text(
                    "usuarioLogado",
                    style: GoogleFonts.raleway(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "Link sugerido: clique ",
                    style: GoogleFonts.raleway(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                TextSpan(
                    text: "aqui!",
                    style: GoogleFonts.raleway(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(Uri.parse(obj.link));
                      })
              ]),
            ),
            SizedBox(height: defaultPadding * 3),
          ],
        ),
      ),
      //BOTÃO FLUTUANTE
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: Icon(
          Icons.keyboard_return,
        ),
        onPressed: () {
          //Voltar para TelaPrincipal
          Navigator.pop(context);
        },
      ),
    );
  }
}
