import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:busify_gerant/Widgets/SimpleAlertDialog.dart';
import 'package:busify_gerant/controllers/Bus_controller.dart';
import 'package:busify_gerant/controllers/Driver_controller.dart';
import 'package:busify_gerant/models/Bus_model.dart';
import 'package:busify_gerant/models/Driver_model.dart';
import 'package:busify_gerant/views/BusInfos_view.dart';
import 'package:busify_gerant/views/DriverInfos_view.dart';
import 'package:busify_gerant/views/LineInfos_view.dart';
import 'package:busify_gerant/views/QRview.dart';
import 'package:busify_gerant/views/newAccount_views/AddLine_view.dart';
import 'package:busify_gerant/widgets/Loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DashboardView extends StatefulWidget {
  final SharedPreferences prefs;
  const DashboardView({required this.prefs});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {

  bool darkmode = false;
  dynamic savedThemeMode;

  Future getCurrentTheme() async {
    savedThemeMode = await AdaptiveTheme.getThemeMode();
    if (savedThemeMode.toString() == 'AdaptiveThemeMode.dark') {
      print('mode sombre');
      setState(() {
        darkmode = true;
      });
    } else {
      setState(() {
        darkmode = false;
      });
      print('mode clair');
    }
  }

  SharedPreferences? prefs;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  bool loading = false;

  @override
  initState(){
    initPrefs();
    super.initState();
    getCurrentTheme();
  }

  BusController busController = BusController();
  DriverController drController = DriverController();

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    void showSimpleDialog(String title, String content){
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return SimpleAlertDialog(title: title, content: content,);
        },
      );
    }


    List data = [
      
      {
        'title' : "Bus",
        'subtitle' : "Informations de votre bus",
      },

      {
        'title' : "Chauffeur",
        'subtitle' : "Informations personnelles",
      },

      {
        'title' : "Ligne",
        'subtitle' : "Informations sur la ligne du bus",
      },
      {
        'title' : "Supprimer",
        'subtitle' : "Quitter le réseau",
      },
      {
        'title' : "Code QR",
        'subtitle' : "Generer le code QR du bus",
      },
      {
        'title' : "Activité",
        'subtitle' : "Le bus est active",
      },

      
    ];

    return SafeArea(
      child: Scaffold(

        appBar: AppBar(
          title: const Text("Busify Gérant"),
          centerTitle: true,
        ),

        drawer: Drawer(
          child: SizedBox(
            width: width,
            child: ListView(
              shrinkWrap: true,
              children: [
                
                const SizedBox(height: 25,),
                
                // Logo
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset("assets/gerant.png"),
                ),

                const SizedBox(height: 20,),

                // Username
                SizedBox(
                  child: Center(
                    child: Text(
                     "Gérant de bus",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),

                const SizedBox(height: 10,),
              
                const Divider(),

                // Ajouter bus
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Card(
                    child: ListTile(
                      leading: Icon(
                        CupertinoIcons.bus,
                        color: Theme.of(context).primaryColor,
                        size: 35,
                      ),
                      title: Text(
                        "Ajouter bus",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      onTap: () async {

                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);

                        setState(() {
                          loading = true;
                        });

                        String webId = prefs!.getString("webId")!; 
                        // ignore: use_build_context_synchronously
                        Map<String, dynamic> json =  {
                          "login" :  {
                            "idp" : "https://solidcommunity.net",
                            "username" : "bus1",
                            "password" : "bus1123456" 
                          },
                          "webId" : "https://bus1.solidcommunity.net",
                          "bus" : {
                            "nom" : "",
                            "matricule" : "",
                            "marque" : "",
                            "line" : "",
                            "activity" : "0"
                          },
                          "driver" : {
                            "nom" : "",
                            "prenom" : "",
                            "birthday" : "",
                            "id" : ""
                          },
                          "location" : {
                            "lat" : "",
                            "lon" : "",
                            "track" : ""  
                          }
                        };

                        bool init = await busController.init(json);

                        print("init");

                        setState(() {
                          loading = false;
                        });
                      

                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: ((context) => AddLine(webId: webId))),
                        );


                        
                      }
                    ),
                  ),
                ),

                const Divider(),

                // Theme
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Card(
                    child: ListTile(
                      leading: Icon(
                        CupertinoIcons.moon_fill,
                        color: Theme.of(context).primaryColor,
                        size: 35,
                      ),
                      title: 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Mode sombre",
                            style: Theme.of(context).textTheme.bodyMedium,  
                          ),
                          
                          CupertinoSwitch(
                            value: darkmode, 
                            activeColor: Colors.amber,
                            onChanged: (value){
                              print(value);
                              if (value == true) {
                                AdaptiveTheme.of(context).setDark();
                              } else {
                                AdaptiveTheme.of(context).setLight();
                              }
                              setState(() {
                                darkmode = value;
                              });
                            }
                          ),
                        ],
                      ) 
                 
                    ),
                  ),
                ),

                const Divider(),

                // Nous contacter
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Card(
                    child: ListTile(
                      leading: Icon(
                        CupertinoIcons.mail_solid,
                        color: Theme.of(context).primaryColor,
                        size: 35,
                      ),
                      title: Text(
                        "Nous contacter",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      onTap: () {
                      },
                    ),
                  ),
                ),

                // A propos
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Card(
                    child: ListTile(
                      leading: Icon(
                        CupertinoIcons.info_circle_fill,
                        color: Theme.of(context).primaryColor,
                        size: 35,
                      ),
                      title: Text(
                        "A propos",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      onTap: () {
                      },
                    ),
                  ),
                ),

                
              ],
            )
          ),
        ),
      
        body:  loading 
        ? const Loading()
        : SizedBox(
          width: width,
          height: height,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  // 
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
    
                         // ! Bus
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () async {

                                if(prefs!.getBool('bus') == null || prefs!.getBool('bus') == false){
                                  showSimpleDialog(
                                    "Oups !",
                                    "Vous devez d'abord ajouter votre bus"
                                  );
                                } else {
                                  setState(() {
                                    loading = true;
                                  });
                      
                                  debugPrint(data[1]["title"]);
                      
                                  Map<String, dynamic> json = {
                                    "webId" : prefs!.getString('webId') 
                                  };
                      
                                  Bus bus = await busController.getBus(json).whenComplete(() {
                                    Future.delayed(
                                      const Duration(seconds: 1),
                                      (){
                                        setState(() {
                                      loading = false;
                                    });
                                      }
                                    );
                                    
                                  });
                      
                                  debugPrint("Le bus arrive");
                                  debugPrint(bus.toString());
                                  
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (context) => BusInfos(bus: bus))
                                  );
                                }
                    
                                
                    
                        
                              },
                              child: Card(
                                // color: Colors.red,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  child: Column(
                                    children: [
                                      
                                      Expanded(
                                        flex: 1,
                                        child: Hero(
                                          tag : 'bus',
                                          child: Icon(
                                            CupertinoIcons.bus,
                                            color: Theme.of(context).primaryColor,
                                            size: 50,
                                          ),
                                        ),
                                      ),
                            
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: ListTile(
                                            title: Text(data[0]["title"]),
                                            subtitle: Text(data[0]["subtitle"]),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ),
                            ),
                          ),
                          
                          // ! Driver
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () async {
                                
                                if(prefs!.getBool('bus') == null || prefs!.getBool('bus') == false){
                                  showSimpleDialog(
                                    "Oups !",
                                    "Vous devez d'abord ajouter votre bus"
                                  );
                                } else {
                                  setState(() {
                                    loading = true;
                                  });
                      
                                  debugPrint(data[2]["title"]);
                      
                                  Map<String, dynamic> json = {
                                    "webId" : prefs!.getString('webId') 
                                  };
                      
                                  Driver driver = await drController.getDriver(json).whenComplete(() {
                                    Future.delayed(
                                      const Duration(seconds: 1),
                                      (){
                                        setState(() {
                                      loading = false;
                                    });
                                      }
                                    );
                                    
                                  });
                      
                                  debugPrint(driver.toString());
                                  
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (context) => DriverInfo(driver: driver))
                                  );
                                }

                                
                    
                              },
                              child: Card(
                                // color: Colors.red,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  child: Column(
                                    children: [
                                      
                                      Expanded(
                                        flex: 1,
                                        child: Hero(
                                          tag: 'driver',
                                          child: Icon(
                                            CupertinoIcons.person_fill,
                                            color: Theme.of(context).primaryColor,
                                            size: 50,
                                          ),
                                        ),
                                      ),
                            
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: ListTile(
                                            title: Text(data[1]["title"]),
                                            subtitle: Text(data[1]["subtitle"]),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
    
                  const SizedBox(height: 10,),
    
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          
                          // ! LINE
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: (){
                                
                                if(prefs!.getBool('bus') == null || prefs!.getBool('bus') == false){
                                  showSimpleDialog(
                                    "Oups !",
                                    "Vous devez d'abord ajouter votre bus"
                                  );
                                } else {

                                  debugPrint(data[3]["title"]);

                                  int? line = prefs!.getInt("line");

                                  print("Ligne = ${line.toString()}");

                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (context) => LineInfos(line: line!) )
                                  );
                                } 

                              
                              },
                              child: Card(
                                // color: Colors.red,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  child: Column(
                                    children: [
                                      
                                      Expanded(
                                        flex: 1,
                                        child: Hero(
                                          tag: 'line',
                                          child: Icon(
                                            Icons.roundabout_right_rounded,
                                            color: Theme.of(context).primaryColor,
                                            size: 50,
                                          ),
                                        ),
                                      ),
                                
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: ListTile(
                                            title: Text(data[2]["title"]),
                                            subtitle: Text(data[2]["subtitle"]),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ),
                            ),
                          ),
    
                          const SizedBox(width: 10,),
                  
                          // ! Delete
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: (){
                                if(prefs!.getBool('bus') == null || prefs!.getBool('bus') == false){
                                  showSimpleDialog(
                                    "Oups !",
                                    "Vous devez d'abord ajouter votre bus"
                                  );
                                } else {
                                  showSimpleDialog(
                                    "Attention !",
                                    "Cela va supprimer toutes vos données"
                                  );
                                } 
                              },
                              child: Card(
                                // color: Colors.red,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  child: Column(
                                    children: [
                                      
                                      Expanded(
                                        flex: 1,
                                        child: Icon(
                                          CupertinoIcons.delete,
                                          color: Theme.of(context).primaryColor,
                                          size: 50,
                                        ),
                                      ),
                                
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: ListTile(
                                            title: Text(data[3]["title"]),
                                            subtitle: Text(data[3]["subtitle"]),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ),
                            ),
                          ),
                  
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10,),
    
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          
                          // ! QR
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                if(prefs!.getBool('bus') == null || prefs!.getBool('bus') == false){
                                  showSimpleDialog(
                                    "Oups !",
                                    "Vous devez d'abord ajouter votre bus"
                                  );
                                } else {

                                  Map<String, dynamic> data = {
                                    "scan" : "bus",
                                    "qr" : {
                                      "login" : {
                                          "idp" : "https://solidcommunity.net",
                                          "username" : "bus1",
                                          "password" : "bus1123456" 
                                      },
                                      "webId" : "https://bus1.solidcommunity.net"
                                    }
                                  };

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => QRView(data: data,))
                                  );
                                } 
                              },
                              child: Card(
                                // color: Colors.red,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  child: Column(
                                    children: [
                                      
                                      Expanded(
                                        flex: 1,
                                        child: Icon(
                                          CupertinoIcons.qrcode,
                                          color: Theme.of(context).primaryColor,
                                          size: 50,
                                        ),
                                      ),
                                
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: ListTile(
                                            title: Text(data[4]["title"]),
                                            subtitle: Text(data[4]["subtitle"]),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ),
                            ),
                          ),
    
                          const SizedBox(width: 10,),
                  
                          // ! Activity
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: (){
                                if(prefs!.getBool('bus') == null || prefs!.getBool('bus') == false){
                                  showSimpleDialog(
                                    "Oups !",
                                    "Vous devez d'abord ajouter votre bus"
                                  );
                                } else {

                                  if (prefs!.getInt('active') == 0) {
                                    showCupertinoDialog(
                                    context: context, 
                                    builder: (context)=> CupertinoAlertDialog(
                                        title: const Text("Activité"),
                                        content: const Text("Attention, cela va rendre votre bus détectable"),
                                        actions: [
                                          CupertinoDialogAction(
                                            child: Text(
                                              "D'accord",
                                              style: TextStyle(color: Theme.of(context).primaryColor),
                                            ),
                                            onPressed: () async {

                                              setState(() {
                                                loading = true;
                                              });

                                              Navigator.pop(context);

                                              Map<String, dynamic> json = {
                                                "webId" : prefs!.getString('webId') 
                                              };
                                              await busController.getBus(json).then((bus) async {

                                                Map<String, dynamic> login = {
                                                  "idp" : "https://solidcommunity.net",
                                                  "username" : "bus1",
                                                  "password" : "bus1123456"
                                                };

                                                Map<String, dynamic> busData = {
                                                  "login" : login,
                                                  "webId" : "https://bus1.solidcommunity.net",
                                                  "bus" : {
                                                    "nom" : bus.name,
                                                    "marque" : bus.marque,
                                                    "matricule" : bus.matricule,
                                                    "line" : prefs!.getInt('line'),
                                                    "activity" : "1",
                                                  }
                                                };

                                                Map<String, dynamic> webId = {
                                                  "webId" : "https://bus1.solidcommunity.net"
                                                };

                                                await busController.updateBus(busData);

                                                await busController.addBus(webId);

                                                prefs!.setInt('active', 1);

                                                setState(() {
                                                  print("activité");
                                                  loading = false;
                                                });

                                              });

                                            }
                                          ),
                                          CupertinoDialogAction(
                                            child: Text(
                                              "Annuler",
                                              style: TextStyle(color: Theme.of(context).primaryColor),
                                            ),
                                            onPressed: (){
                                              Navigator.pop(context);
                                            }
                                          ),
                                        ],
                                        )
                                      );
                                  } else {
                                    showCupertinoDialog(
                                    context: context, 
                                    builder: (context)=> CupertinoAlertDialog(
                                        title: const Text("Activité"),
                                        content: const Text("Attention, cela va rendre votre bus non détectable"),
                                        actions: [
                                          CupertinoDialogAction(
                                            child: Text(
                                              "D'accord",
                                              style: TextStyle(color: Theme.of(context).primaryColor),
                                            ),
                                            onPressed: () async {
                                              setState(() {
                                                loading = true;
                                              });

                                              Navigator.pop(context);

                                              Map<String, dynamic> json = {
                                                "webId" : prefs!.getString('webId') 
                                              };
                                              await busController.getBus(json).then((bus) async {

                                                Map<String, dynamic> login = {
                                                  "idp" : "https://solidcommunity.net",
                                                  "username" : prefs!.getString('username'),
                                                  "password" : prefs!.getString('password')
                                                };

                                                Map<String, dynamic> busData = {
                                                  "login" : login,
                                                  "webId" : prefs!.getString('webId'),
                                                  "bus" : {
                                                    "nom" : bus.name,
                                                    "marque" : bus.marque,
                                                    "matricule" : bus.matricule,
                                                    "line" : prefs!.getInt('line'),
                                                    "activity" : "0",
                                                  }

                                                };

                                                Map<String, dynamic> webId = {
                                                  "webId" : "https://bus1.solidcommunity.net"
                                                };

                                                await busController.updateBus(busData);

                                                await busController.removeBus(webId);

                                                prefs!.setInt('active', 0);

                                                
                                                // ignore: use_build_context_synchronously
                                                setState(() {
                                                  print("activité");
                                                  loading = false;
                                                });

                                              });

                                            }
                                          ),
                                          CupertinoDialogAction(
                                            child: Text(
                                              "Annuler",
                                              style: TextStyle(color: Theme.of(context).primaryColor),
                                            ),
                                            onPressed: (){
                                              Navigator.pop(context);
                                            }
                                          ),
                                        ],
                                        )
                                      );
                                    
                                  }
                                } 
                              },
                              child: Card(
                                // color: Colors.red,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  child: Column(
                                    children: [
                                      
                                      Expanded(
                                        flex: 1,
                                        child: widget.prefs.getInt('active') == null 
                                        ? const CupertinoSwitch( value: false,  onChanged: null)
                                        : widget.prefs.getInt('active') == 0 
                                        ? const CupertinoSwitch( value: false,  onChanged: null)
                                        : const CupertinoSwitch( value: true, onChanged: null)
                                         
                                      ),
                                
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: ListTile(
                                            title: Text(data[5]["title"]),
                                            subtitle: 
                                            widget.prefs.getInt('active') == null 
                                            ? const Text("Ajoutez d'abord un bus")
                                            : widget.prefs.getInt('active') == 0 
                                            ? const Text("Le bus est non détectable")
                                            : const Text("Le bus est détectable")
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ),
                            ),
                          ),
                  
                        ],
                      ),
                    ),
                  ),
    
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 10 ),
                  //   child: SizedBox(
                  //     child: CupertinoButton(
                  //       color: Theme.of(context).primaryColor,
                  //       child: const Text("Supprimer le compte"), 
                  //       onPressed: (){
    
                  //         showCupertinoDialog(
                  //           context: context,
                  //           builder: (context) {
                  //             return CupertinoAlertDialog(
                  //               title: const Text("Attention"),
                  //               content: const Text("Cela va supprimere toutes vos données"),
                  //               actions: [
    
                  //                 CupertinoDialogAction(
                  //                   child: Text(
                  //                     "Annuler",
                  //                     style: TextStyle(color: Theme.of(context).primaryColor),
                  //                   ),
                  //                   onPressed: (){ 
                  //                     Navigator.pop(context);
                  //                   }
                  //                 ),
                  //                 CupertinoDialogAction(
                  //                   child: Text(
                  //                     "Supprimer",
                  //                     style: TextStyle(color: Theme.of(context).primaryColor),
                  //                   ),
                  //                   onPressed: (){ 
                  //                     prefs!.remove('username');
                  //                     prefs!.remove('password');
                  //                     prefs!.remove('webId');
                  //                     prefs!.remove('line');
    
                  //                     Navigator.pop(context);
                  //                     Navigator.pop(context);
                  //                     Navigator.pop(context);
                                     
    
                  //                   }
                  //                 ),
                  //               ],
                  //             );
                  //           },
                  //         );
                  //       }
                  //     ),
                  //   ),
                  // )
    
                  
    
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}