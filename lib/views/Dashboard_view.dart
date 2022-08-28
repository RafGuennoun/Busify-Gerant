import 'package:busify_gerant/controllers/Bus_controller.dart';
import 'package:busify_gerant/controllers/Driver_controller.dart';
import 'package:busify_gerant/widgets/Loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {

  SharedPreferences? prefs;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  bool loading = false;
  @override
  initState(){
    initPrefs();
    super.initState();
  }

  BusController busController = BusController();
  DriverController drController = DriverController();

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;


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
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout_rounded
              ),
              onPressed: (){

                showCupertinoDialog(
                  context: context, 
                  builder: (context)=> CupertinoAlertDialog(
                    title: const Text("Déconnexion"),
                    content: const Text("Voulez vous vraiment vous déconnecter"),
                    actions: [
                      CupertinoDialogAction(
                        child: Text(
                          "Oui",
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: (){
                          // prefs!.remove('username');
                          // prefs!.remove('password');
                          // prefs!.remove('webId');
                          // prefs!.setBool('login', false);

                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(builder: ((context) => const DashboardView())),
                          // );
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
                

               
              }, 
            )
          ],
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
                            child: Card(
                              // color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                child: Column(
                                  children: [
                                    
                                    Expanded(
                                      flex: 1,
                                      child: Icon(
                                        CupertinoIcons.bus,
                                        color: Theme.of(context).primaryColor,
                                        size: 50,
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
                          
                          // ! Driver
                          Expanded(
                            flex: 1,
                            child: Card(
                              // color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                child: Column(
                                  children: [
                                    
                                    Expanded(
                                      flex: 1,
                                      child: Icon(
                                        CupertinoIcons.person_fill,
                                        color: Theme.of(context).primaryColor,
                                        size: 50,
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
    
                          const SizedBox(width: 10,),
                  
                          // ! Delete
                          Expanded(
                            flex: 1,
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
    
                          const SizedBox(width: 10,),
                  
                          // ! ADD
                          Expanded(
                            flex: 1,
                            child: Card(
                              // color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                child: Column(
                                  children: [
                                    
                                    Expanded(
                                      flex: 1,
                                      // child: Icon(
                                      //   CupertinoIcons.tornado,
                                      //   color: Theme.of(context).primaryColor,
                                      //   size: 50,
                                      // ),
                                      child: CupertinoSwitch(
                                        
                                        value: false, 
                                        onChanged: (val){}
                                      ),
                                    ),
    
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: ListTile(
                                          title: Text(data[5]["title"]),
                                          subtitle: Text(data[5]["subtitle"]),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
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