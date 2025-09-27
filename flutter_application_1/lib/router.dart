import 'package:flutter/material.dart';
import 'package:flutter_application_1/Authen/login_page.dart';
import 'package:flutter_application_1/states/authen.dart';
import 'package:flutter_application_1/states/create_account.dart';
import 'package:flutter_application_1/states/home.dart';

final Map<String, WidgetBuilder> map = {
  '/login': (BuildContext context) => const LoginPage(),
  '/authen': (BuildContext context) => Authen(),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/home': (BuildContext context) => homepage(),
};