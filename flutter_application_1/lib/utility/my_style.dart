import 'package:flutter/material.dart';

class MyStyle {

  Color blueColor = Color(0xff39AFEA);
  Color primaryColor = Color(0xFFEFA104);
  Color lightColor = Color(0xffF4F4FB);
  Color blackColor = Color(0xff000000);

  TextStyle blackStyle() => TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16);
  TextStyle whiteStyle() => TextStyle(color: Colors.white);
  TextStyle pinkStyle() => TextStyle(color: Colors.pink,  fontWeight: FontWeight.w700); 

  Widget showLogo() => Image(image: AssetImage('images/logo.png'),
  );

  SafeArea buildBackground(double screenWidth, double screenHeight) {
    return SafeArea(
      child: Container(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            Positioned(
                top: 0, 
                left: 0, 
                child: Image.asset('images/top1.png')
            ),
             Positioned(
                top: 0, 
                left: 0, 
                child: Image.asset('images/top2.png')
            ),
             Positioned(
                bottom : 0, 
                left: 0, 
                child: Image.asset('images/bottom1.png')
            ),
             Positioned(
                bottom: 0, 
                left: 0, 
                child: Image.asset('images/bottom2.png')
            ),
          ],
        ),
      ),
    );
  }

  MyStyle();

}