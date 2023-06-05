import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';

//
// MENSAGEM DE ERRO
//
void erro(context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.redAccent.withOpacity(0.4),
      content: Text(
        msg,
        style: const TextStyle(color: Colors.white),
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}

//
// MENSAGEM DE SUCESSO
//
void sucesso(context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: kPrimaryColor,
      content: Text(
        msg,
        style: const TextStyle(color: Colors.white),
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}
