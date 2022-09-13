import 'package:busify_gerant/views/Login_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({ Key? key }) : super(key: key);

  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {

  SharedPreferences? prefs;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  initState(){
    initPrefs();
    super.initState();
  }

  List infos = [
    {
      "title" : "Busify Gérant",
      "body" : "Cette application permet aux gérants de bus de manipuler les différentes données ",
      "image" : "assets/gerant.png"
    },

    {
      "title" : "Données géographiques",
      "body" : "Cette application utilise Openstreetmap comme outil pour récupérer les coordonnées géographiques.",
      "image" : "assets/osm_logo.png"
    },

    {
      "title" : "Stockage de données",
      "body" : "L'application utilise la plateforme Solid pour une meilleure sécurité et propriété de données.",
      "image" : "assets/solid_logo.png"
    },

  ]; 


  @override
  Widget build(BuildContext context) {

    Widget buildImage(String path){
      return Center(
        child: Image.asset(path, width: 250,) ,
      );
    }

    PageDecoration getPageDecoration(){
      return PageDecoration(
        titleTextStyle: const TextStyle(
          fontFamily: 'Poppins', fontWeight: FontWeight.bold, 
          fontSize: 28, 
          color: Colors.black87
        ),

        bodyTextStyle: const TextStyle(
          fontFamily: 'Poppins', fontWeight: FontWeight.normal, 
          fontSize: 16, 
          color: Colors.black87
        ),

        bodyPadding: const EdgeInsets.all(16).copyWith(bottom: 0),
        imagePadding: const EdgeInsets.all(24),
        pageColor: Colors.white
      );
    }

    DotsDecorator getDotsDecoration(){
      return DotsDecorator(
        color: Colors.grey,
        size: const Size(10,10),
        activeColor: Colors.blue,
        activeSize: const Size(25, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24)
        )
      );
    }

    return SafeArea(
      child: IntroductionScreen(
        pages: [

          PageViewModel(
            title: infos[0]['title'],
            body: infos[0]['body'],
            image: buildImage(infos[0]['image']),
            decoration: getPageDecoration()
          ), 

          PageViewModel(
            title: infos[1]['title'],
            body: infos[1]['body'],
            image: buildImage(infos[1]['image']),
            decoration: getPageDecoration()
          ), 

          PageViewModel(
            title: infos[2]['title'],
            body: infos[2]['body'],
            image: buildImage(infos[2]['image']),
            decoration: getPageDecoration()
          ), 

          

        ],
        done: const Icon(
          CupertinoIcons.arrow_right_circle_fill,
          size: 35,
        ),
        onDone: (){
          prefs!.setBool("intro", true);

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginView())
          );
        },
        showSkipButton: true,
        skip: const Text(
          "Skip",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontFamily: 'Poppins',
          ),
        ),
        dotsDecorator: getDotsDecoration(),
        // globalBackgroundColor: darkmode ? clr.bleuFonce : clr.blanc,
        globalBackgroundColor: Colors.white,
        showNextButton: false,
      ),

    );
      
  }
}