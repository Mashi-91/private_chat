import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:private_chat/screens/splash_screen.dart';
import 'firebase_options.dart';
import 'package:private_chat/screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:private_chat/screens/home_screen.dart';

late Size mq;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    var result = await FlutterNotificationChannel.registerNotificationChannel(
      id: 'chats',
      name: 'Chats',
      description: 'For showing Message Notification',
      importance: NotificationImportance.IMPORTANCE_HIGH,
    );
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Private Chat',
      theme: ThemeData(
          appBarTheme: AppBarTheme(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: GoogleFonts.firaSansCondensed(
            fontWeight: FontWeight.normal, color: Colors.black, fontSize: 22),
        backgroundColor: Colors.white,
        elevation: 1,
      )),
      home: SplashScreen(),
    );
  }
}
