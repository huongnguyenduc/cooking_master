import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBase {
  User get currentUser;

  // Future<UserModel> getModelUser();

  Stream<User> authStateChanges();

  Future<User> signInAnonymously();

  Future<String> signInWithEmailAndPassword(String email, String password);

  Future<String> createUserWithEmailAndPassword(String email, String password);

  Future<User> signInWithGoogle();

  Future<User> signInWithFacebook();

  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;
  String errorMessage;

  @override
  Stream<User> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  User get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User> signInAnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    return userCredential.user;
  }

  @override
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }

    return "OK";
  }

  @override
  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    UserCredential userCredential;

    try {
      userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
    return "OK";
  }

  @override
  Future<User> signInWithGoogle() async {
    final googleSignIn = new GoogleSignIn();
    UserCredential userCredential;

    try {
      final googleSignInAccount = await googleSignIn.signIn().catchError((e) {
        errorMessage = e;
        print(errorMessage);
      });

      final googleSignInAuth =
          await googleSignInAccount.authentication.catchError((e) {
        errorMessage = e;
        print(errorMessage);
      });

      final googleCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuth.accessToken,
          idToken: googleSignInAuth.idToken);

      userCredential =
          await _firebaseAuth.signInWithCredential(googleCredential);
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      errorMessage = e.message;
      return null;
    } catch (e) {
      errorMessage = e;
      print(errorMessage);
      return null;
    }

    return userCredential.user;
  }

  @override
  Future<User> signInWithFacebook() async {
    final facebookLogin = new FacebookLogin();
    UserCredential userCredential;

    try {
      FacebookLoginResult facebookLoginResult =
          await facebookLogin.logIn(['email']);
      switch (facebookLoginResult.status) {
        case FacebookLoginStatus.cancelledByUser:
          print('Facebook login cancelled by user');
          return null;
        case FacebookLoginStatus.error:
          errorMessage = 'Facebook login error';
          return null;
        case FacebookLoginStatus.loggedIn:
          FacebookAccessToken facebookAccessToken =
              facebookLoginResult.accessToken;
          OAuthCredential authCredential =
              FacebookAuthProvider.credential(facebookAccessToken.token);
          userCredential =
              await _firebaseAuth.signInWithCredential(authCredential);
          break;
        default:
          print('Error unknown');
          break;
      }
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      errorMessage = e.message;
      return null;
    }

    return userCredential.user;
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    await _firebaseAuth.signOut();

  }
}
