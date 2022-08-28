import 'package:busify_gerant/controllers/Node_controller.dart';
import 'package:busify_gerant/controllers/Relation_controller.dart';
import 'package:busify_gerant/models/Node_model.dart';
import 'package:busify_gerant/models/Realtion_model.dart';
import 'package:busify_gerant/views/newAccount_views/AddDriver&Bus_view.dart';
import 'package:busify_gerant/views/node_views/StopsSelector_view.dart';
import 'package:busify_gerant/views/relation_views/RelationLocation_view.dart';
import 'package:busify_gerant/widgets/Error.dart';
import 'package:busify_gerant/widgets/Loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StopsGenerator extends StatefulWidget {

  final Map<String, dynamic> data;
  const StopsGenerator({required this.data});

  @override
  State<StopsGenerator> createState() => _StopsGeneratorState();
}

class _StopsGeneratorState extends State<StopsGenerator> {

  Future<List<Node>>? nodes;
  Future<Relation>? rel;
  
  NodeController nodeRepo = NodeController();
  RelationController relRepo = RelationController();
  
  @override
  void initState() {
    super.initState();
    nodes = nodeRepo.buildNodes(widget.data['ligne']);
    rel = relRepo.getRelationOSM(widget.data['ligne']);
  }

  int nb = 3;

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
  
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Arrets"),
          centerTitle: true,
        ),
    
        body: SingleChildScrollView(
          child: SizedBox(
            width: width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 25, 25, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informations sur la ligne ${widget.data['ligne']} :',
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.bodyMedium
                  ),
    
                  const SizedBox(height: 15,),
                  
                  // Infos ligne
                  FutureBuilder<Relation>(
                    future: rel,
                    builder: ( context, snapshot) {
                      print(snapshot.connectionState);
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 60,
                          child: Center(
                            child: Loading()
                          )
                        );
                      } else if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return const ErrorLogo();
                        } else if (snapshot.hasData) {
                          // ! C'est ici que ca se passe
    
                          Relation ligne = snapshot.data as Relation;
    
                          return Card(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.add_road_outlined,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    title: Text(
                                      ligne.name,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        "Identifiant : ${ligne.id}",
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ),
                                  ),
                                ),
    
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: ListTile(
                                    leading: Icon(
                                      CupertinoIcons.wifi,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    title: Text(
                                      ligne.network,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        "Le reseau au quel appartient la ligne",
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ),
                                  ),
                                ),
    
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: ListTile(
                                    leading: Icon(
                                      CupertinoIcons.stop_circle,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    title: Text(
                                      ligne.from,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        "Arrêt terminus",
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ),
                                  ),
                                ),
    
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: ListTile(
                                    leading: Icon(
                                      CupertinoIcons.stop_circle,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    title: Text(
                                      ligne.to,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        "Arrêt terminus",
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ),
                                  ),
                                ),
    
                                
                              ],
                            ),
                          );
                          
                          // return Text(snapshot.data.toString());
                        } else {
                          return const Text('Empty data');
                        }
                      } else {
                        return Text('State: ${snapshot.connectionState}');
                      }
                    },
                  ),
                  
                  const SizedBox(height: 15,),
    
                  Text(
                    'Arrets disponible dans cette ligne :',
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.bodyMedium
                  ),
    
                  const SizedBox(height: 15,),
    
                  // Nodes
                  FutureBuilder<List<Node>>(
                    future: nodes,
                    builder: ( context, snapshot) {
                      print(snapshot.connectionState);
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 60,
                          child: Center(
                            child: Loading()
                          )
                        );
                      } else if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return const ErrorLogo();
                        } else if (snapshot.hasData) {
                          // ! C'est ici que ca se passe
    
                          List<Node> arrets = snapshot.data as List<Node>; 
    
                          return Column(
                            children: [
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: nb,
                                itemBuilder: (context, index) {
                                  Node arret = arrets[index];
                                  return Card(
                                    child: ListTile(
                                    title: Text(
                                      arret.name,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    subtitle: Text(
                                      "ID : ${arret.id.toString()}",
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                    leading: Icon(
                                      CupertinoIcons.bus,
                                      color: Theme.of(context).primaryColor
                                    ),
                                  ),
                                  );
                                },
                              ),
    
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      child: CupertinoButton(
                                        child: FittedBox(
                                          child: Text(
                                            nb == 3 ? 'Tout afficher' : 'Afficher moins' ,
                                            style: Theme.of(context).textTheme.bodySmall
                                          ),
                                        ),
                                        onPressed: () {
                                          // TODO: FIX THIS
                                          setState(() {
                                            if (nb == 3) {
                                              nb = arrets.length;
                                            } else {
                                              nb = 3;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
    
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      child: CupertinoButton(
                                        child: FittedBox(
                                          child: Text(
                                            'Voir la map',
                                            style: Theme.of(context).textTheme.bodySmall
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context, 
                                            MaterialPageRoute(builder: (context) => RelationLocations(arrets: arrets))
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
    
                              const SizedBox(height: 5,),
    
                              CupertinoButton(
                                color: Theme.of(context).primaryColor,
                                child: const Text('Suivant'),
                                onPressed: () {
                                  print("Continer");
    
                                  Map<String, dynamic> newData = {
                                    "login" : widget.data["login"],
                                    "ligne" : widget.data["ligne"],
                                    "nodes" : arrets
                                  };
    
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (context) => StopsSelector(data: newData))
                                  );
                                },
                              ),
    
                              const SizedBox(height: 25,),
    
                              Text(
                                "Ignorer pour selectionner tout les arrêts",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
    
                              CupertinoButton(
                                child: Text(
                                  'Ignorer',
                                  style: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 14,
                                    color: Theme.of(context).primaryColor
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (context) => AddDriverAndBus(data: widget.data))
                                  );
                                },
                              ),
    
                           
           
                              
    
                              // Text(
                              //   "Ignonez pour selectionner tout les arrêts de la ligne",
                              //   style: Theme.of(context).textTheme.bodySmall,
                              // ),
    
                              // CupertinoButton(
                              //   child: Text(
                              //     'Ignorer',
                              //     style: TextStyle(
                              //       fontFamily: 'Poppins', fontSize: 14,
                              //       color: Theme.of(context).primaryColor
                              //     ),
                              //   ),
                              //   onPressed: () {
                              //     // TODO: FIX THIS
                              //   },
                              // ),
    
    
                            ],
                          );
                          
                          // return Text(snapshot.data.toString());
                        } else {
                          return const Text('Empty data');
                        }
                      } else {
                        return Text('State: ${snapshot.connectionState}');
                      }
                    },
                  ),
    
                  const SizedBox(height: 25,),
    
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}