import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Forgot_password/forgot_password_screen.dart';
import '../../Signup/signup_screen.dart';

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
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
              onPressed: () {},
              child: Text(
                "Enviar".toUpperCase(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()));
              },
              child: Text(
                "Voltar ao início",
                style: TextStyle(color: kPrimaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
