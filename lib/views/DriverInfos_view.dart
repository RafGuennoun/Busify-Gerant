
import 'package:busify_gerant/controllers/Driver_controller.dart';
import 'package:busify_gerant/models/Driver_model.dart';
import 'package:busify_gerant/widgets/Loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Widgets/SimpleAlertDialog.dart';


class DriverInfo extends StatefulWidget {
  final Driver driver;
  const DriverInfo({required this.driver});

  @override
  State<DriverInfo> createState() => _DriverInfoState();
}

class _DriverInfoState extends State<DriverInfo> {

  DriverController driverController = DriverController(); 

  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _idController = TextEditingController();

  bool? empty = false;

  bool read = true;

  bool load = false;
  
  late SharedPreferences prefs;

  Future initPrefs() async {
    // instance
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    initPrefs();
    super.initState();
    _nomController.text = widget.driver.nom;
    _prenomController.text = widget.driver.prenom;
    _idController.text = widget.driver.id;
  }

  @override
  void dispose() {
    super.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _idController.dispose();
  }

  void showDialog(String title, String content){
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return SimpleAlertDialog(title: title, content: content,);
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Informations chauffeur"),
          centerTitle: true,
        ),
    
        body: SingleChildScrollView(
          child: SizedBox(
            width: width,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
        
                  Hero(
                    tag: 'driver',
                    child: Icon(
                      CupertinoIcons.person_fill,
                      color: Theme.of(context).primaryColor,
                      size: 150,
                    ),
                  ),
        
                  const SizedBox(height: 45,),
        
                  
                  // NOM
                  TextField(
                    controller: _nomController,
                    readOnly: read,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(CupertinoIcons.person_solid),
                      labelText: "Nom",
                      labelStyle: Theme.of(context).textTheme.bodyMedium,
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      errorText: empty == true ? "Nom obligatoire" : null,
                    ),
                    onChanged: (newText) {
                      setState(() {
                        empty = false;
                      });
                    },
                  ),
        
                  const SizedBox(height: 20,),
        
                  // Prenom
                  TextField(
                    controller: _prenomController,
                    readOnly: read,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(CupertinoIcons.person_solid),
                      labelText: "Prenom",
                      labelStyle: Theme.of(context).textTheme.bodyMedium,
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      errorText: empty == true ? "Prenom obligatoire" : null,
                    ),
                    onChanged: (newText) {
                      setState(() {
                        empty = false;
                      });
                    },
                  ),
        
                  const SizedBox(height: 20,),
        
                  // id
                  TextField(
                    controller: _idController,
                    readOnly: read,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(CupertinoIcons.number),
                      labelText: "Numéro d'identité",
                      labelStyle: Theme.of(context).textTheme.bodyMedium,
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      errorText: empty == true ? "Numéro ID obligatoire" : null,
                    ),
                    onChanged: (newText) {
                      setState(() {
                        empty = false;
                      });
                    },
                  ),
    
                  const SizedBox(height: 30,),
    
                  load ? const Loading() 
                  : CupertinoButton(
                    color: Theme.of(context).primaryColor,
                    child: Text( read ? "Modifier" : "Enregistrer"), 
                    onPressed: () async {
                      if (read) {
                        setState(() {
                          _nomController.text = '';
                          _prenomController.text = '';
                          _idController.text = '';
                          read = false;
                        });
                        
                      } else {
                        // update data
    
                        if (
                          _nomController.text.isEmpty || 
                          _prenomController.text.isEmpty ||
                          _idController.text.isEmpty 
                        ) {
                          
                          showDialog(
                            "Oups !",
                            "Veuillez remplir tout les champs"
                          );
                          
                        } else {
    
                          setState(() {
                            load = true;
                          });
    
                          Map<String, dynamic> json = {
                            "login" :  {
                              "idp" : "https://solidcommunity.net",
                              "username" : prefs.getString('username'),
                              "password" : prefs.getString('password') 
                            },
                            "webId" : prefs.getString('webId'),
                             "driver" : {
                              "nom" : _nomController.text,
                              "prenom" : _prenomController.text,
                              "birthday" : widget.driver.birthday,
                              "id" : _idController.text
                            },
                          };
    
    
                          bool up = await driverController.updateDriver(json).whenComplete((){
                            Future.delayed(
                              const Duration(milliseconds: 500),
                              (){
                                setState(() {
                                  load = false;
                                  read = true;
                                });
                              }
                            );
                          });
    
                          
                        }
    
                      }
                    }
                  )
        
                 
        
                
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}