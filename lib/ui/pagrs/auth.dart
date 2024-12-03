import 'package:flutter/material.dart';
import 'package:unichat_app/ui/pagrs/HomePage.dart';
import 'package:unichat_app/ui/pagrs/Loign.dart';
import 'package:unichat_app/utilites/sharedPref_helper.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPrefrenceHelper.getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          const Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          );
        }
        if (snapshot.hasError) {
          print('we hsve error');
        }
        print('snapS is ${snapshot.data}');
        return snapshot.data != null ? Homepage() : Loign();
      },
    );
  }
}
