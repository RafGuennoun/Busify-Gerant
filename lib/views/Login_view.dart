import 'package:busify_gerant/controllers/Account_controller.dart';
import 'package:busify_gerant/models/Account_model.dart';
import 'package:busify_gerant/views/Dashboard_view.dart';
import 'package:busify_gerant/views/newAccount_views/CreatePOD.dart';
import 'package:busify_gerant/widgets/Loading.dart';
import 'package:busify_gerant/widgets/SimpleAlertDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
 
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

  AccountController accController = AccountController();

  SharedPreferences? prefs;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  initState(){
    initPrefs();
    super.initState();
  }

  bool loading = false;

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

    return SafeArea(
      child: Scaffold(
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

                  //App logo
                  SizedBox(
                    width: width*0.3,
                    height: width*0.3,
                    child: Center(
                      child: Image.asset('assets/gerant.png'),
                    ),
                  ),
    
                  const SizedBox(height: 15,),
    
                  SizedBox(
                    child: Center(
                      child: Text(
                        'Busify Gérant',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),

                  const SizedBox(height: 45,),
                  
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ajoutez les informations de votre POD :',
                          style: Theme.of(context).textTheme.bodyMedium,
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 25,),
                  // CupertinoButton(child: child, onPressed: onPressed)

                  loading ? const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Loading()
                  )
                  : Column(
                    children: [
                      CupertinoButton(
                        color: Theme.of(context).primaryColor,
                        child: const Text('Se connercter'),
                        onPressed: () async {

                          if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
                            String title = "Oups !";
                            String content = "Veuillez remplir tous les champs.";
                            showSimpleDialog(title, content);
                            
                          } else {

                            bool hasInternet = await InternetConnectionChecker().hasConnection;

                            if (hasInternet) {
                              
                              setState(() {
                                loading = true;
                              });
                              
                              Map<String, dynamic> authData = {
                                "idp" : "https://solidcommunity.net",
                                "username" : _usernameController.text,
                                "password" : _passwordController.text
                              }; 

                              Account acc = await accController.getAccount(authData);

                              if (acc.username == 'null') {
                                showSimpleDialog(
                                  "Erreur !", 
                                  "Verifiez les informations de votre POD."
                                );
                                setState(() {
                                  loading = false;
                                });
                              } else {

                                prefs!.setString("username", acc.username);
                                prefs!.setString("password", acc.password);
                                prefs!.setString("webId", acc.webId);
                                prefs!.setBool("login", true);


                                debugPrint(acc.toString());
                                showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: const Text("Connecté"),
                                      content: const Text("Authentification au POD avec succées"),
                                      actions: [
                                        CupertinoDialogAction(
                                          child: Text(
                                            "Continuer",
                                            style: TextStyle(color: Theme.of(context).primaryColor),
                                          ),
                                          onPressed: ()
                                          { 

                                            setState(() {
                                              loading = false;
                                            });

                                            Navigator.pop(context);

                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(builder: ((context) => DashboardView(prefs: prefs!,))),
                                              (route) => false
                                            );
                                          }
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            } else {
                              showSimpleDialog(
                                "Oups !", 
                                "Verifiez votre connexion internet."
                              );
                            }
                          }
                        },
                      ),

                      const SizedBox(height: 30,),

                      Text(
                        "Apprendre comment créer un POD",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),

                      CupertinoButton(
                        child: Text(
                          'Guide pour créer un POD',
                          style: TextStyle(
                            fontFamily: 'Poppins', fontSize: 14,
                            color: Theme.of(context).primaryColor
                          ),
                        ),
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CreatePOD())
                          );
                        }
                      ),
                      const SizedBox(height: 10,),

                      Text(
                        "Site pour créer un POD",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),

                      CupertinoButton(
                        child: Text(
                          'solidcommunity.net',
                          style: TextStyle(
                            fontFamily: 'Poppins', fontSize: 14,
                            color: Theme.of(context).primaryColor
                          ),
                        ),
                        onPressed: () async{
                          final Uri url = Uri.parse('https://solidcommunity.net/register');
                          if (!await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          )) {
                            showSimpleDialog(
                              "Oups", 
                              "Une erreur est survenu, veuillez réessayer."
                            );
                          }
                        }
                      ),
                    ],
                  ),

                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}