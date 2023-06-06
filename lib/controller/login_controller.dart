import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';

import '../Screens/view/TelaPrincipal/tela_principal.dart';
import '../util.dart';

class LoginController {
  //
  // CRIAR UMA NOVA CONTA no serviço
  // Firebase Authentication
  //
  criarConta(context, nome, email, senha) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: senha)
        .then((resultado) {
      //
      // Armazenar o nome do usuário no Firebase Firestore
      //
      FirebaseFirestore.instance.collection('usuarios').add({
        'uid': resultado.user!.uid,
        'nome': nome,
      });

      sucesso(context, 'Agora sua vida financeira vai pra outro patamar 🤑😎');
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }).catchError((e) {
      switch (e.code) {
        case 'email-already-in-use':
          erro(context, 'O email já foi utilizado.');
          break;
        case 'invalid-email':
          erro(context, 'O formato do email é inválido');
          break;
        default:
          erro(context, 'ERRO: ${e.code.toString()}');
      }
    });
  }

  //
  // LOGIN
  //
  login(context, email, senha) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: senha)
        .then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const TelaPrincipal();
          },
        ),
      );
    }).catchError((e) {
      switch (e.code) {
        case 'user-not-found':
          erro(context, 'Usuário não encontrado.');
          break;
        default:
          erro(context, 'ERRO: ${e.code.toString()}');
      }
    });
  }

  //
  // ESQUECEU A SENHA
  //
  esqueceuSenha(context, String email) {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text("Recuperação de Senha"),
                content: Text(
                    "Um email contendo instruções de recuperação de senha foi enviado para $email"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text("OK"),
                  )
                ],
              ));
    }).catchError((e) {
      erro(context, 'ERRO: ${e.code.toString()}');
    });
    // Navigator.pop(context);
    // Navigator.push(
    //                 context,
    //                 MaterialPageRoute(
    //                     builder: (context) => const WelcomeScreen()));
  }

  //
  // LOGOUT
  //
  logout() {
    FirebaseAuth.instance.signOut();
  }

  //
  // ID do Usuário Logado
  //
  idUsuario() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  //
  // NOME do Usuário Logado
  //
  Future<String> usuarioLogado() async {
    var usuario = '';
    await FirebaseFirestore.instance
        .collection('usuarios')
        .where('uid', isEqualTo: idUsuario())
        .get()
        .then(
      (resultado) {
        usuario = resultado.docs[0].data()['nome'] ?? '';
      },
    );
    return usuario;
  }

  void alterarNome(context, String nomeUpdate) {
    FirebaseFirestore.instance
        .collection('usuarios')
        .doc(idUsuario())
        .update({'nome': nomeUpdate}).then((value) {
      sucesso(context, 'Nome alterado com sucesso');
    }).catchError((e) {
      erro(context, 'ERRO: ${e.code.toString()}');
    });
  }
}
