import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/router.dart';
import 'package:flutter_application_1/states/authen.dart'; // หน้าล็อกอิน
import 'package:flutter_application_1/states/home.dart'; // หน้าหลักของแอป

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // ต้องรัน Firebase ก่อนใช้
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: map,
      initialRoute: '/', // ตั้งค่าเริ่มต้นเป็นหน้า AuthCheck
      debugShowCheckedModeBanner: false,
      home: AuthCheck(), // ใช้หน้า AuthCheck เพื่อตรวจสอบล็อกอิน
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // โหลดสถานะ
        } else if (snapshot.hasData) {
          return homepage(); // ถ้าล็อกอินแล้ว ไปหน้า Home
        } else {
          return Authen(); // ถ้ายังไม่ได้ล็อกอิน ไปหน้า Login
        }
      },
    );
  }
}
