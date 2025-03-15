import 'package:flutter/material.dart';
import 'package:flutter_application_1/utility/dialog.dart';
import 'package:flutter_application_1/utility/my_style.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authen extends StatefulWidget {
  const Authen({super.key});

  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  double screenWidth = 0;
  double screenHeight = 0;
  bool redEye = true;
  String user = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: buildCreateAccount(context),
      body: SafeArea(
        child: Stack(
          children: [
            MyStyle().buildBackground(screenWidth, screenHeight),
            Positioned(
              top: 40,
              left: 16,
              child: bulidLogo(),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildUser(),
                  buildPassword(),
                  buildSignInEmail(),
                  //buildSignInGoogle(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildCreateAccount(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 50,
        ),
        Text(
          'None Account ?',
          style: MyStyle().whiteStyle(),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/createAccount');
          },
          child: Text(
            'Create Account',
            style: MyStyle().blackStyle(),
          ),
        ),
      ],
    );
  }

  Container buildSignInEmail() => Container(
      margin: EdgeInsets.only(top: 16),
      child: SignInButton(
        Buttons.Email,
        onPressed: () => processSignInWithEmail(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ));

  Container buildSignInGoogle() => Container(
      margin: EdgeInsets.only(top: 16),
      child: SignInButton(
        Buttons.GoogleDark,
        onPressed: () => processSignInWithGoogle(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ));

  Future<Null> processSignInWithEmail() async {
    try {
      await Firebase.initializeApp();
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user,
        password: password,
      );
      print('Sign in with email success: ${userCredential.user}');
      // Navigate to the home page or another page
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      print('Sign in with email failed: $e');
      normalDialog(context, 'Error', 'Failed to sign in with email. Please try again.');
    }
  }

  Future<Null> processSignInWithGoogle() async {
    const List<String> scopes = <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ];

    GoogleSignIn googleSignIn = GoogleSignIn(
      // Optional clientId
      clientId: 'your-client_id.apps.googleusercontent.com',
      scopes: scopes,
    );

    try {
      await Firebase.initializeApp();
      print('Firebase Initialized Successfully');
      await googleSignIn.signIn().then((onValue) async {
        print('Login with Google success');
        GoogleSignInAccount? googleUser = onValue;
        GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        print('User signed in: ${userCredential.user}');
        // Navigate to the home page or another page
        Navigator.pushReplacementNamed(context, '/home');
      }).catchError((onError) {
        print('Google Sign-In Error: ${onError.code} - ${onError.message}');
        normalDialog(context, onError.code, onError.message);
      });
    } catch (e) {
      print('Error initializing Firebase: $e');
      normalDialog(context, 'Error', 'Failed to initialize Firebase. Please try again.');
    }
  }

  Container buildUser() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: screenWidth * 0.6,
      child: TextField(
        onChanged: (value) => user = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.perm_identity),
          labelStyle: MyStyle().blackStyle(),
          labelText: 'User :',
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: MyStyle().blackColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: MyStyle().blackColor)),
        ),
      ),
    );
  }

  Container buildPassword() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: screenWidth * 0.6,
      child: TextField(
        obscureText: redEye,
        onChanged: (value) => password = value.trim(),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              redEye
                  ? Icons.remove_red_eye_outlined
                  : Icons.remove_red_eye_sharp,
            ),
            onPressed: () {
              setState(() {
                redEye = !redEye;
              });
            },
          ),
          prefixIcon: Icon(Icons.lock_outlined),
          labelStyle: MyStyle().blackStyle(),
          labelText: 'Password :',
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: MyStyle().blackColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: MyStyle().blackColor)),
        ),
      ),
    );
  }

  Container bulidLogo() {
    return Container(
      width: screenWidth * 0.4,
      child: MyStyle().showLogo(),
    );
  }
}
