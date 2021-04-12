import 'package:cooking_master/screens/sign_in/email_sign_in_form.dart';
import 'package:flutter/material.dart';

class EmailSignInPage extends StatelessWidget {

  const EmailSignInPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EmailSignInType _formType;
    final changeText = _formType == EmailSignInType.SignIn ?
    '  Sign Up' : ' Sign In';
    return Scaffold(
      appBar: AppBar(
        title: Text(changeText),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: EmailSignInForm()
            //EmailSignInFormChangeNotifier.create(context),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
