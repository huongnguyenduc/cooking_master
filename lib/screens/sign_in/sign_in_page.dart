import 'package:cooking_master/screens/sign_in/background-image.dart';
import 'package:cooking_master/screens/sign_in/email_sign_in_form.dart';
import 'package:cooking_master/screens/sign_in/social_sign_in_button.dart';
import 'package:cooking_master/services/auth_service.dart';
import 'package:cooking_master/services/userprofile_service.dart';
import 'package:cooking_master/widgets/show_exception_alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  //const
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // final SignInManager manager;
  //final bool isLoading;
  static const Key emailPasswordKey = Key('email-password');

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlertDialog(
      context,
      title: 'Sign in failed',
      exception: exception,
    );
  }

  // Future<void> _signInAnonymously(BuildContext context) async {
  //   try {
  //     // await manager.signInAnonymously();
  //     final auth = Provider.of<AuthBase>(context, listen: false);
  //     await auth.signInAnonymously();
  //   } on Exception catch (e) {
  //     _showSignInError(context, e);
  //   }
  // }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      //await manager.signInWithGoogle();
      final auth = Provider.of<AuthBase>(context, listen: false);
      final userProfile =
          Provider.of<UserProfileService>(context, listen: false);
      var user = await auth.signInWithGoogle();
      userProfile.addUser(user.uid);
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      final userProfile =
          Provider.of<UserProfileService>(context, listen: false);
      var user = await auth.signInWithFacebook();
      userProfile.addUser(user.uid);
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    EmailSignInType _formType;
    final changeText =
        _formType == EmailSignInType.SignIn ? '  Sign Up' : ' Sign In';
    return Scaffold(
      body: _buildContent(context),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildContent(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      LoginBackgroundImage(),
      SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 50.0,
                child: _buildHeader(),
              ),
              SizedBox(height: 80.0),
              EmailSignInForm(),
              Text(
                'or',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25.0),
              SocialSignInButton(
                assetName: 'assets/images/google-logo.png',
                text: 'Sign in with Google',
                textColor: Colors.black87,
                color: Colors.white,
                onPressed: () => _signInWithGoogle(context),
                //isLoading ? null : () => _signInWithGoogle(context),
              ),
              SizedBox(height: 25.0),
              SocialSignInButton(
                assetName: 'assets/images/facebook-logo.png',
                text: 'Sign in with Facebook',
                textColor: Colors.white,
                color: Color(0xFF334D92),
                onPressed: () => _signInWithFacebook(context),
                //onPressed: isLoading ? null : () => _signInWithFacebook(context),
              ),
              //SizedBox(height: 25.0),
              // SignInButton(
              //   key: emailPasswordKey,
              //   text: 'Sign in with email',
              //   textColor: Colors.white,
              //   color: Colors.blueAccent,
              //   onPressed: () => _signInWithEmail(context),
              //   //onPressed: isLoading ? null : () => _signInWithEmail(context),
              // ),
              //SizedBox(height: 15.0),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget _buildHeader() {
    if (false) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      'Cooking Master',
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 32.0, fontWeight: FontWeight.w600, color: Colors.white),
    );
  }
}
