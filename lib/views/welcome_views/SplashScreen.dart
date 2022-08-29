
import 'dart:async';
import 'package:busify_gerant/views/Dashboard_view.dart';
import 'package:busify_gerant/views/Login_view.dart';
import 'package:busify_gerant/views/welcome_views/IntroductionPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

   SharedPreferences? prefs;
  Future check() async {
    
    // instance
   prefs = await SharedPreferences.getInstance();
    
    bool? intro = prefs!.getBool('intro');
    bool? login = prefs!.getBool('login');
    
    if (intro == null) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const IntroductionPage()));
    } else {
      if (login == null || login == false) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginView()));
      } else {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => DashboardView(prefs: prefs!,)));
      }
    }


  }

  @override
  void initState() {
    super.initState();
    
    Timer(
      const Duration(milliseconds: 1500),
      (){
        check();
      } 
    );
    
  }
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(child: Text("Splash")) 
      ),
    );
  }
}