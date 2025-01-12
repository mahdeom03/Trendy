// ignore_for_file: unused_import

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
  //حالة user
  // @override
  // void initState() {
  //   FirebaseAuth.instance.authStateChanges().listen((User? user) {
  //     if (user == null) {
  //       print('========================User is currently signed out!');
  //     } else {
  //       print('=================User is signed in!');
  //     }
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          // useMaterial3: true,
          ),
      // home: SplashScreen(),
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
