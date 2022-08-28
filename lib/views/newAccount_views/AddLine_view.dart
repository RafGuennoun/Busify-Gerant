import 'package:busify_gerant/views/node_views/StopsGenerator_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Widgets/SimpleAlertDialog.dart';

class AddLine extends StatefulWidget {

  final Map<String, dynamic> authData;

  const AddLine({required this.authData});

  @override
  State<AddLine> createState() => _AddLineState();
}

class _AddLineState extends State<AddLine> {

  final _lignController = TextEditingController();

  bool? empty;

  late SharedPreferences prefs;

  Future initPrefs() async {
    // instance
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    initPrefs();
    super.initState();
    _lignController.text = "7996451";
  }

  @override
  void dispose() {
    super.dispose();
    _lignController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    void showDialog(String title, String content){
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return SimpleAlertDialog(title: title, content: content,);
        },
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ligne"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
            child: SizedBox(
              width: width,
              // height: height*0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  //App logos
                  appLogos(width, context),
    
                  const SizedBox(height: 30,),
    
                  // Text explicatif
                  explainTexts(context),

                  const SizedBox(height: 15,),
                  
                  TextField(
                    controller: _lignController,
                    // autofocus: true,
                    readOnly: true,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(CupertinoIcons.number),
                      labelText: "Identifiant de ligne ",
                      labelStyle: Theme.of(context).textTheme.bodyMedium,
                      hintText: "Entrez l'identifiant de la ligne",
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      errorText: empty == true ? "Identifiant obligatoire" : null,
                    ),
                    onChanged: (newText) {
                      setState(() {
                        empty = false;
                      });
                    },
                  ),

                  const SizedBox(height: 20,),

                  CupertinoButton(
                    color: Theme.of(context).primaryColor,
                    child: const Text('Conituer'),
                    onPressed: () async {

                      if (_lignController.text.isEmpty) {
                        showDialog(
                          "Oups !", 
                          "Veuillez introduire l'identifiant de la ligne"
                        );
                      } else {

                        bool hasInternet = await InternetConnectionChecker().hasConnection;

                        if (hasInternet) {

                          Map<String, dynamic> authData = widget.authData;
                          int line = int.parse(_lignController.text);

                          Map<String, dynamic> data = {
                            "login" : authData,
                            "ligne" : line
                          };

                          prefs.setInt("line", line );

                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: ((context) => StopsGenerator(data: data)))
                          );
                        
                        } else {
                          showDialog(
                            "Oups !", 
                            "Verifiez votre connexion internet."
                          );
                        }

                     
                        
                      }

                      
                    },
                  ),

                  const SizedBox(height: 35,),

                  Text(
                    "Vous ne connaissez pas OpenStreetMap ?",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),

                  CupertinoButton(
                    child: Text(
                      'OpenStreetMap',
                      style: TextStyle(
                        fontFamily: 'Poppins', fontSize: 14,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    onPressed: () async {
                      final Uri url = Uri.parse('https://www.openstreetmap.org/#map=5/28.413/1.653');
                      if (!await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      )) {
                        showDialog(
                          "Oups", 
                          "Une erreur est survenu."
                        );
                      }
                    },
                  ),

                  
                ],
              ),
            ),
          ),
        ),
    );
  }

  SizedBox appLogos(double width, BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: width*0.3,
            height: width*0.3,
            color: Theme.of(context).primaryColor,
            child: const Center(child: Text("LOGO")),
          ),

          SizedBox(
            width: width*0.3,
            height: width*0.3,
            child: Center(
              child: Image.asset(
                'assets/osm_logo.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column explainTexts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informations',
          style: Theme.of(context).textTheme.titleMedium,
        ),

        const SizedBox(height: 5,),

        Text(
          "Notre application utilise les données OpenStreetMap. OpenStreetMap (OSM) est un projet collaboratif de cartographie en ligne qui vise à constituer une base de données géographiques libre du monde.",
          textAlign: TextAlign.justify,
          style: Theme.of(context).textTheme.bodyMedium,
        ),

        const SizedBox(height: 10,),

        Text(
          "Pour utiliser l'application, vous devez recuperer l'identifiant de la ligne dans OpenstreetMap et l'application sen contentera du reste.",
          textAlign: TextAlign.justify,
          style: Theme.of(context).textTheme.bodyMedium,
        ),

      ],
    );
  }
}