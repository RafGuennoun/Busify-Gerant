import 'package:busify_gerant/controllers/Account_controller.dart';
import 'package:busify_gerant/views/Dashboard_view.dart';
import 'package:busify_gerant/views/newAccount_views/CreatePOD.dart';
import 'package:busify_gerant/widgets/Loading.dart';
import 'package:busify_gerant/widgets/SimpleAlertDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solid_auth/solid_auth.dart';
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
                          "Authnetification au POD",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),

                        // const SizedBox(height: 25,),

                        // // username
                        // TextField(
                        //   controller: _usernameController,
                        //   // autofocus: true,
                        //   textAlign: TextAlign.center,
                        //   style: Theme.of(context).textTheme.bodyMedium,
                        //   decoration: InputDecoration(
                        //     border: const OutlineInputBorder(),
                        //     prefixIcon: const Icon(CupertinoIcons.person_fill),
                        //     labelText: "Nom d'utilisateur ",
                        //     labelStyle: Theme.of(context).textTheme.bodyMedium,
                        //     hintText: "Entrez votre nom d'utulisateur",
                        //     hintStyle: Theme.of(context).textTheme.bodyMedium,
                        //     errorText: empty == true ? "Nom d'utulisateur obligatoire" : null,
                            
                        //   ),
                        //   onChanged: (newText) {
                        //     setState(() {
                        //       empty = false;
                        //     });
                        //   },
                        // ),

                        // const SizedBox(height: 15,),

                        // // Password
                        // TextField(
                        //   controller: _passwordController,
                        //   obscureText: obscure,
                        //   autofocus: false,
                        //   textAlign: TextAlign.center,
                        //   style: Theme.of(context).textTheme.bodyMedium,
                        //   decoration: InputDecoration(
                        //     prefixIconColor: Theme.of(context).primaryColor,
                        //     prefixIcon: const Icon(
                        //       CupertinoIcons.lock_fill,
                        //     ),
                        //     suffixIcon: IconButton(
                        //       icon: Icon(
                        //         obscure ? CupertinoIcons.eye_solid : CupertinoIcons.eye_slash_fill,
                        //         color: obscure ? Colors.grey[500] : Theme.of(context).primaryColor,
                        //       ),
                        //       onPressed: (){
                        //         setState(() {
                        //           obscure = !obscure;
                        //         });
                        //       }, 
                        //     ),
                        //     border: const OutlineInputBorder(),
                        //     labelText: "Mot de passe ",
                        //     labelStyle: Theme.of(context).textTheme.bodyMedium,
                        //     hintText: "Entrez votre mot de passe",
                        //     hintStyle: Theme.of(context).textTheme.bodyMedium,
                        //     errorText: empty == true ? "Nom d'utulisateur obligatoire" : null
                        //   ),
                        //   onChanged: (newText) {
                        //     setState(() {
                        //       empty = false;
                        //     });
                        //   },
                        // ),
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

                          setState(() {
                            loading = true;
                          });
                          
                          // Example WebID
                          String myWebId = 'https://grafik.solidcommunity.net/profile/card#me';

                          // Get issuer URI
                          String issuerUri = await getIssuer(myWebId);

                          // Define scopes. Also possible scopes -> webid, email, api
                          final List<String> scopes = <String>[
                            'openid',
                            'profile',
                            'offline_access',
                          ];

                          // Authentication process for the POD issuer
                          var authData = await authenticate(Uri.parse(issuerUri), scopes, context);

                          print("authData");
                          print(authData);

                          // Decode access token to recheck the WebID
                          String accessToken = authData['accessToken'];
                          Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
                          String webId = decodedToken['webid'];

                          String result = webId.replaceAll('/profile/card#me', '');

                          prefs!.setString("webId", result);

                          setState(() {
                            loading = false;
                          });

                          showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: const Text("Authentification"),
                                content: Column(
                                  children: [
                                    const Text("Votre Web ID :"),
                                    Text(webId),
                                  ],
                                ),
                                actions: [

                                  CupertinoDialogAction(
                                    child: Text(
                                      "Continuer",
                                      style: TextStyle(color: Theme.of(context).primaryColor),
                                    ),
                                    onPressed: (){ 
                                      Navigator.pop(context);
                                      Navigator.pushAndRemoveUntil(
                                        context, 
                                        MaterialPageRoute(builder: (context)=> DashboardView(prefs: prefs!)),
                                        (Route route) => false
                                      );
                                    }
                                  ),
                                ],
                              );
                            },
                          );
                        }
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