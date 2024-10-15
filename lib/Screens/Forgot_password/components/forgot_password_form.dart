import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/controller/login_controller.dart';

import '../../../constants.dart';

class ForgotPasswordForm extends StatelessWidget {
  ForgotPasswordForm({
    Key? key,
  }) : super(key: key);
  var email = TextEditingController();
  //adicionar futuramente regex para tratar email
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: InputDecoration(
              hintText: "Seu email",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.email),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "enviar_btn",
            child: ElevatedButton(
              onPressed: () {
                LoginController().esqueceuSenha(context, email.text);
              },
              child: Text(
                "Enviar".toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextButton(
              child: Text(
                "Voltar ao início",
                style: TextStyle(color: kPrimaryColor),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WelcomeScreen()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
