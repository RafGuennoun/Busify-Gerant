
import 'package:busify_gerant/controllers/Bus_controller.dart';
import 'package:busify_gerant/models/Bus_model.dart';
import 'package:busify_gerant/widgets/Loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Widgets/SimpleAlertDialog.dart';


class BusInfos extends StatefulWidget {
  final Bus bus;
  const BusInfos({required this.bus});

  @override
  State<BusInfos> createState() => _BusInfosState();
}

class _BusInfosState extends State<BusInfos> {

  BusController busController = BusController();

  final _nomController = TextEditingController();
  final _marqueController = TextEditingController();
  final _matController = TextEditingController();

  bool? empty = false;

  bool read = true;

  bool load = false;
  
  SharedPreferences? prefs;

  Future initPrefs() async {
    // instance
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    initPrefs();
    super.initState();
    _nomController.text = widget.bus.name;
    _marqueController.text = widget.bus.marque;
    _matController.text = widget.bus.matricule;
  }

  @override
  void dispose() {
    super.dispose();
    _nomController.dispose();
    _marqueController.dispose();
    _matController.dispose();
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
          title: const Text("Bus infos"),
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
                    tag: 'bus',
                    child: Icon(
                      CupertinoIcons.bus,
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
                      prefixIcon: const Icon(CupertinoIcons.bus),
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
        
                  // Marque
                  TextField(
                    controller: _marqueController,
                    readOnly: read,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(CupertinoIcons.bookmark_fill),
                      labelText: "Marque",
                      labelStyle: Theme.of(context).textTheme.bodyMedium,
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      errorText: empty == true ? "Marque obligatoire" : null,
                    ),
                    onChanged: (newText) {
                      setState(() {
                        empty = false;
                      });
                    },
                  ),
        
                  const SizedBox(height: 20,),
        
                  // Matricule
                  TextField(
                    controller: _matController,
                    readOnly: read,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(CupertinoIcons.number),
                      labelText: "Matricule",
                      labelStyle: Theme.of(context).textTheme.bodyMedium,
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      errorText: empty == true ? "Matricule obligatoire" : null,
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
                          _marqueController.text = '';
                          _matController.text = '';
                          read = false;
                        });
                        
                      } else {
                        // update data
    
                        if (
                          _nomController.text.isEmpty || 
                          _marqueController.text.isEmpty ||
                          _matController.text.isEmpty 
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
                              "username" : prefs!.getString('username'),
                              "password" : prefs!.getString('password') 
                            },
                            "webId" : prefs!.getString('webId'),
                            "bus" : {
                              "nom" : _nomController.text,
                              "matricule" : _matController.text,
                              "marque" : _marqueController.text,
                              "line" : prefs!.getInt('line').toString(),
                              "activity" : "0"
                            }
                          };
    
    
                          bool up = await busController.updateBus(json).whenComplete((){
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