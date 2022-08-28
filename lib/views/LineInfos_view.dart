
import 'package:busify_gerant/controllers/Relation_controller.dart';
import 'package:busify_gerant/models/Realtion_model.dart';
import 'package:busify_gerant/widgets/Loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LineInfos extends StatefulWidget {
  final int line;
  const LineInfos({required this.line});

  @override
  State<LineInfos> createState() => _LineInfosState();
}

class _LineInfosState extends State<LineInfos> {

  RelationController relController = RelationController();

  Future<Relation>? rel;

  

  @override
  void initState() {
    super.initState();
      rel = relController.getRelationOSM(widget.line);
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;

    return Scaffold(
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
                  tag: 'line',
                  child: Icon(
                    Icons.roundabout_right_rounded,
                    color: Theme.of(context).primaryColor,
                    size: 150,
                  ),
                ),
      
                const SizedBox(height: 45,),
      
      
                // Infos ligne
                FutureBuilder<Relation>(
                  future: rel,
                  builder: ( context, snapshot) {
                    print(snapshot.connectionState);
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 100,
                        child: Center(
                          child: Loading()
                        )
                      );
                    } else if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return const Text('Error');
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
               
              
              ],
            ),
          ),
        ),
      )
    );
  }
}