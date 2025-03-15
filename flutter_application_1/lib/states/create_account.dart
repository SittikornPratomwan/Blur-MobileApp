import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/utility/dialog.dart';
import 'package:flutter_application_1/utility/my_style.dart';
import 'package:flutter_application_1/states/home.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  double screenWidth = 0;
  double screenHeight = 0;
  String roomnumber = '';
  String user = '';
  String password = '';
  String confirmPassword = '';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Container buildroomnumber() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: screenWidth * 0.6,
      child: TextField(
        onChanged: (value) => roomnumber = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.perm_identity),
          labelStyle: MyStyle().blackStyle(),
          labelText: 'Phone Number :',
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
        obscureText: _obscurePassword,
        onChanged: (value) => password = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock_outlined),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
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

  Container buildConfirmPassword() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: screenWidth * 0.6,
      child: TextField(
        obscureText: _obscureConfirmPassword,
        onChanged: (value) => confirmPassword = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock_outlined),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
          labelStyle: MyStyle().blackStyle(),
          labelText: 'Confirm Password :',
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

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
        backgroundColor: MyStyle().primaryColor,
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildContent(),
            ],
          ),
          MyStyle().buildBackground(screenWidth, screenHeight),
        ],
      ),
    );
  }

  Center buildContent() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildroomnumber(),
            buildUser(),
            buildPassword(),
            buildConfirmPassword(),
            buildCreateAccount(),
          ],
        ),
      ),
    );
  }

  Container buildCreateAccount() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: screenWidth * 0.6,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: MyStyle().primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        onPressed: () {
          if ((user?.isEmpty ?? true) ||
              (password?.isEmpty ?? true) ||
              (confirmPassword?.isEmpty ?? true)) {
            print('Have Space');
            normalDialog(context, 'Input Required !!!',
                'Please enter a value. This field cannot be empty.');
          } else if (password != confirmPassword) {
            print('Passwords do not match');
            normalDialog(context, 'Password Mismatch',
                'The passwords do not match. Please try again.');
          } else {
            createAccountAndInsertInformation();
          }
        },
        icon: Icon(Icons.cloud_upload, color: Colors.white),
        label: Text('Create Account', style: MyStyle().whiteStyle()),
      ),
    );
  }

  Future<Null> createAccountAndInsertInformation() async {
  await Firebase.initializeApp().then((value) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: user, password: confirmPassword)
        .then((value) async {
      String uid = value.user!.uid;

      UserModel model = UserModel(email: user, roomnumber: roomnumber);
      Map<String, dynamic> data = model.toMap();

      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .set(data)
          .then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => homepage()), // ล็อกอินอัตโนมัติ
        );
      });
    }).catchError((onError) =>
        normalDialog(context, onError.code, onError.message));
  });
}

  


}
