import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:private_chat/api/api.dart';
import 'package:private_chat/screens/auth/login_screen.dart';
import 'package:private_chat/screens/home_screen.dart';

import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      //exit Full-Screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark));
      if (APIs.auth.currentUser != null) {
        return Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
      } else {
        return Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: mq.height * .15,
              right: mq.width * .28,
              width: mq.width * .4,
              child: Image.asset('assets/images/icon.png')),
          Positioned(
              bottom: mq.height * .15,
              width: mq.width,
              child: Text(
                'MADE BY MASHI',
                textAlign: TextAlign.center,
                style: GoogleFonts.titilliumWeb(
                  fontSize: 22,
                  letterSpacing: .5,
                  fontWeight: FontWeight.bold,
                ),
              ))
        ],
      ),
    );
    ;
  }
}
