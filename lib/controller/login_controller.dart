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
        'primeiroacesso': true,
      });

      sucesso(context, 'Agora sua vida financeira vai pra outro patamar');
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

  Future<bool> getPrimeiroAcesso(context) async {
    bool primeiroacesso = true;
    await FirebaseFirestore.instance
        .collection('usuarios')
        .where('uid', isEqualTo: idUsuario())
        .get()
        .then(
      (resultado) {
        primeiroacesso = resultado.docs[0].data()['primeiroacesso'];
      },
    );
    return primeiroacesso;
  }

  void acessou(context) {
    var user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;

      // Consulta o Firestore para encontrar o documento pelo campo 'uid'
      FirebaseFirestore.instance
          .collection('usuarios')
          .where('uid', isEqualTo: uid)
          .limit(1) // Limita a consulta a um único resultado
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          // Pega o Document ID do primeiro documento retornado
          String docId = querySnapshot.docs.first.id;

          // Atualiza o campo 'primeiroacesso' no documento encontrado
          FirebaseFirestore.instance
              .collection('usuarios')
              .doc(docId)
              .update({'primeiroacesso': false}).then((value) {
            // Sucesso (ajuste conforme necessário)
            // sucesso(context, 'Acesso registrado com sucesso');
          }).catchError((e) {
            erro(context, 'ERRO: ${e.toString()}');
          });
        } else {
          // Caso nenhum documento seja encontrado
          erro(context, 'ERRO: Documento não encontrado.');
        }
      }).catchError((e) {
        erro(context, 'ERRO: ${e.toString()}');
      });
    } else {
      erro(context, 'ERRO: Usuário não autenticado');
    }
  }
}
