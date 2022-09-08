import 'package:busify_gerant/controllers/Bus_controller.dart';
import 'package:busify_gerant/controllers/Driver_controller.dart';
import 'package:busify_gerant/controllers/Location_controller.dart';
import 'package:busify_gerant/views/Dashboard_view.dart';
import 'package:busify_gerant/widgets/Loading.dart';
import 'package:busify_gerant/widgets/SimpleAlertDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRData extends StatefulWidget {
  
  final String webId;
  final Map<String, dynamic> bus;
  final Map<String, dynamic> driver;
  
  const QRData({required this.webId, required this.bus, required this.driver});

  @override
  State<QRData> createState() => _QRDataState();
}

class _QRDataState extends State<QRData> {

  SharedPreferences? prefs;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  initState(){
    initPrefs();
    super.initState();
  }

   
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool? empty;

  bool obscure = true;

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
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

  BusController busController = BusController();
  DriverController driverController = DriverController();
  LocationController locationController = LocationController();

  
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("QR code"),
          centerTitle: true,
        ),

        body: SizedBox(
          width: width,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Column(
                children: [
                  Text(
                    "Création du code QR",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 10,),
                  
                  Text(
                    "Pour la géneration du code QR de votre bus vous devez remplir les champs avec les informations necessiares.",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    "Les données seront cryptés et seront utilisées pour génerer le code QR de votre bus.",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.justify,
                  ),

                  const SizedBox(height: 25,),

                  // username
                  TextField(
                    controller: _usernameController,
                    // autofocus: true,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(CupertinoIcons.person_fill),
                      labelText: "Nom d'utilisateur ",
                      labelStyle: Theme.of(context).textTheme.bodyMedium,
                      hintText: "Entrez votre nom d'utulisateur",
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      errorText: empty == true ? "Nom d'utulisateur obligatoire" : null,
                      
                    ),
                    onChanged: (newText) {
                      setState(() {
                        empty = false;
                      });
                    },
                  ),

                  const SizedBox(height: 15,),

                  // Password
                  TextField(
                    controller: _passwordController,
                    obscureText: obscure,
                    autofocus: false,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      prefixIconColor: Theme.of(context).primaryColor,
                      prefixIcon: const Icon(
                        CupertinoIcons.lock_fill,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure ? CupertinoIcons.eye_solid : CupertinoIcons.eye_slash_fill,
                          color: obscure ? Colors.grey[500] : Theme.of(context).primaryColor,
                        ),
                        onPressed: (){
                          setState(() {
                            obscure = !obscure;
                          });
                        }, 
                      ),
                      border: const OutlineInputBorder(),
                      labelText: "Mot de passe ",
                      labelStyle: Theme.of(context).textTheme.bodyMedium,
                      hintText: "Entrez votre mot de passe",
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      errorText: empty == true ? "Nom d'utulisateur obligatoire" : null
                    ),
                    onChanged: (newText) {
                      setState(() {
                        empty = false;
                      });
                    },
                  ),

                  const SizedBox(height: 25,),

                  loading ? const Loading() 
                  : CupertinoButton(
                    color: Theme.of(context).primaryColor,
                    child: const Text("Créer"), 
                    onPressed: () async {

                      if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
                        
                        showDialog(
                          "Oups !", 
                          "Veillez remplir tous les champs."
                        );
                      } else {

                        setState(() {
                          loading = true;
                        });

                        Map<String, dynamic> login = {
                          "idp" : "https://solidcommunity.net",
                          "username" : _usernameController.text.trim(),
                          "password" : _passwordController.text.trim(),
                        };

                        Map<String, dynamic> location = {
                          "lat" : "",
                          "lon" : "",
                          "track" : ""
                        }; 

                        print(location);

                        Map<String, dynamic> initFiles = {
                          "login" :  login,
                          "webId" : widget.webId,
                          "bus" : widget.bus,
                          "driver" : widget.driver,
                          "location" : location
                        };

                        bool? init = await busController.init(initFiles);

                        prefs!.setBool('bus', true);
                        prefs!.setInt('active', 1);
                        prefs!.setString("username", _usernameController.text.trim());
                        prefs!.setString("password", _passwordController.text.trim());



                        if(init){

                          showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: const Text("Seccués"),
                                content: const Text("Votre bus a été ajouté."),
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
                          });

                        } else {
                           showDialog(
                            "Erreur", 
                            "Srat kach haja."
                          );
                        }
              

                        
                      }

                    }
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}