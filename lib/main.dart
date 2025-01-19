import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unichat_app/provider/cartProvider.dart';
import 'package:unichat_app/ui/pagrs/HomePage.dart';
import 'package:unichat_app/ui/pagrs/Loign.dart';
import 'package:unichat_app/ui/pagrs/Mypro.dart';
import 'package:unichat_app/ui/pagrs/OnboardingPage.dart';
import 'package:unichat_app/ui/pagrs/PayPage.dart';
import 'package:unichat_app/ui/pagrs/SignUP.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unichat_app/ui/pagrs/Splash_Screen.dart';
import 'package:unichat_app/ui/pagrs/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => CartProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      initialRoute: "SplashScreen",
      routes: {
        "SplashScreen": (context) => SplashScreen(),
        "Onboarding": (context) => OnboardingPage(),
        'auth': (context) => AuthPage(),
        "Loign": (context) => Loign(),
        "Sign up": (context) => Signup(),
        "Homepage": (context) => Homepage(),
        "Mypro": (context) => MyPro(),
        "paypage": (context) => Paypage(),
      },
    );
  }
}
