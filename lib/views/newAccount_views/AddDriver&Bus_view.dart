import 'package:busify_gerant/controllers/Bus_controller.dart';
import 'package:busify_gerant/controllers/Driver_controller.dart';
import 'package:busify_gerant/views/Dashboard_view.dart';
import 'package:busify_gerant/widgets/Loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/SimpleAlertDialog.dart';

class AddDriverAndBus extends StatefulWidget {
  final Map<String, dynamic> data;
  const AddDriverAndBus({required this.data});

  @override
  State<AddDriverAndBus> createState() => _AddDriverAndBusState();
}

class _AddDriverAndBusState extends State<AddDriverAndBus> {

  SharedPreferences? prefs;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  initState(){
    initPrefs();
    super.initState();
  }

  BusController busController = BusController();
  DriverController driverController = DriverController();

  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _idController = TextEditingController();
  final _busController = TextEditingController();
  final _marqueController = TextEditingController();
  final _matriculeController = TextEditingController();

  bool? empty = false;

  @override
  void dispose() {
    super.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _idController.dispose();
    _busController.dispose();
    _marqueController.dispose();
    _matriculeController.dispose();
  }

  DateTime selectedDate = DateTime.now();
  DateTime lastdDate = DateTime.now();

  Future<String> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1945, 8),
      lastDate: lastdDate
    );
    String formattedDate = ""; 
    if (picked != null && picked != selectedDate) {
     
      print(picked.toString());  //pickedDate output format => 2021-03-10 00:00:00.000
     
      formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      print(formattedDate); //formatted date output using intl package =>  2021-03-16
     
      setState(() {
        selectedDate = picked;
      });
    }
    return formattedDate;
  }

  void showDialog(String title, String content){
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return SimpleAlertDialog(title: title, content: content,);
      },
    );
  }

  bool loading = false;
  
  @override
  Widget build(BuildContext context) {
    
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
    
        appBar: AppBar(
          title: const Text("Informations"),
          centerTitle: true,
        ),
        
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
            child: SizedBox(
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  
                  // Driver Infos
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informations personnelles :',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),

                        const SizedBox(height: 25,),

                        // Nom
                        TextField(
                          controller: _nomController,
                          // autofocus: true,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(CupertinoIcons.person_fill),
                            labelText: "Nom",
                            labelStyle: Theme.of(context).textTheme.bodyMedium,
                            hintText: "Entrez votre nom",
                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                            errorText: empty == true ? "Nom obligatoire" : null,
                            
                          ),
                          onChanged: (newText) {
                            setState(() {
                              empty = false;
                            });
                          },
                        ),

                        const SizedBox(height: 15,),

                        // prenom
                        TextField(
                          controller: _prenomController,
                          // autofocus: true,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(CupertinoIcons.person_fill),
                            labelText: "Prenom",
                            labelStyle: Theme.of(context).textTheme.bodyMedium,
                            hintText: "Entrez votre prenom",
                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                            errorText: empty == true ? "Prenom obligatoire" : null,
                            
                          ),
                          onChanged: (newText) {
                            setState(() {
                              empty = false;
                            });
                          },
                        ),

                        const SizedBox(height: 15,),

                        // ID
                        TextField(
                          controller: _idController,
                          // autofocus: true,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(CupertinoIcons.number),
                            labelText: "Numero d'identit??",
                            labelStyle: Theme.of(context).textTheme.bodyMedium,
                            hintText: "Entrez votre numero d'identit??",
                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                            errorText: empty == true ? "Numero ID obligatoire" : null,
                            
                          ),
                          onChanged: (newText) {
                            setState(() {
                              empty = false;
                            });
                          },
                        ),

                      ],
                    ),
                  ),

                  const SizedBox(height: 25,),

                  // Bus
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informations de votre bus :',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),

                        const SizedBox(height: 25,),

                        // Nom bus
                        TextField(
                          controller: _busController,
                          // autofocus: true,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(CupertinoIcons.bus),
                            labelText: "Nom du v??hicule",
                            labelStyle: Theme.of(context).textTheme.bodyMedium,
                            hintText: "Entrez le nom du v??hicule",
                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                            errorText: empty == true ? "Nom obligatoire" : null,
                            
                          ),
                          onChanged: (newText) {
                            setState(() {
                              empty = false;
                            });
                          },
                        ),

                        const SizedBox(height: 15,),

                        // marque
                        TextField(
                          controller: _marqueController,
                          // autofocus: true,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(CupertinoIcons.bookmark_fill),
                            labelText: "Marque",
                            labelStyle: Theme.of(context).textTheme.bodyMedium,
                            hintText: "Entrez la marque",
                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                            errorText: empty == true ? "Marque obligatoire" : null,
                            
                          ),
                          onChanged: (newText) {
                            setState(() {
                              empty = false;
                            });
                          },
                        ),

                        const SizedBox(height: 15,),

                        // matricule
                        TextField(
                          controller: _matriculeController,
                          // autofocus: true,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(CupertinoIcons.number),
                            labelText: "Matricule",
                            labelStyle: Theme.of(context).textTheme.bodyMedium,
                            hintText: "Entrez matricule",
                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                            errorText: empty == true ? "Matricule obligatoire" : null,
                            
                          ),
                          onChanged: (newText) {
                            setState(() {
                              empty = false;
                            });
                          },
                        ),

                      ],
                    ),
                  ),
                  const SizedBox(height: 25,),

                  loading 
                  ? const Loading()
                  : CupertinoButton(
                    color: Theme.of(context).primaryColor,
                    child: const Text('Conituer'),
                    onPressed: () async {

                      if (
                        _nomController.text.isEmpty ||
                        _prenomController.text.isEmpty ||
                        _idController.text.isEmpty ||
                        _busController.text.isEmpty ||
                        _marqueController.text.isEmpty ||
                        _matriculeController.text.isEmpty
                      ) {
                        showDialog(
                          "Oups !", 
                          "Veuillez remplir tous les champs."
                        );
                        
                      } else {

                        setState(() {
                          loading = true;
                        });

                        Map<String, dynamic> driver = {  
                          "nom" :  _nomController.text,
                          "prenom" : _prenomController.text,
                          "id" : _idController.text
                        };

                        Map<String, dynamic> bus = {
                          "nom" : _busController.text,
                          "marque" : _marqueController.text,
                          "matricule" : _matriculeController.text,
                          "line" : widget.data["ligne"],
                          "activity" : "1",
                        };

                        prefs!.setBool('bus', true);
                        prefs!.setInt('active', 1);

                        bool addBus = await busController.updateBus({
                          "login" :  {
                            "idp" : "https://solidcommunity.net",
                            "username" : "bus1",
                            "password" : "bus1123456" 
                          },
                          "webId" : "https://bus1.solidcommunity.net",
                          "bus" : bus
                        });

                        print("add bus = $addBus");

                        bool addDriver = await driverController.updateDriver ({
                          "login" :  {
                            "idp" : "https://solidcommunity.net",
                            "username" : "bus1",
                            "password" : "bus1123456" 
                          },
                          "webId" : "https://bus1.solidcommunity.net",
                          "driver" : driver
                        });

                        print("add driver = $addDriver");

                        prefs!.setBool('bus', true);
                        prefs!.setInt('active', 1);

                        setState(() {
                          loading = false;
                        });

                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: const Text("Seccu??s"),
                              content: const Text("Votre bus a ??t?? ajout??."),
                              actions: [
                                CupertinoButton(
                                  child: const Text("Continuer"), 
                                  onPressed: (){
                                    setState(() {
                                      loading = false;
                                    });
                                    Navigator.pushAndRemoveUntil(
                                      context, 
                                      MaterialPageRoute(builder: (context) => DashboardView(prefs: prefs!)), 
                                      (route) => false
                                    );
                                  }
                                )
                              ],
                            );
                          }
                        );

                        
                      }

                    },
                  ),

                  const SizedBox(height: 20,),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}