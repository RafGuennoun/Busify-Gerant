import 'package:busify_gerant/controllers/Node_controller.dart';
import 'package:busify_gerant/models/Node_model.dart';
import 'package:busify_gerant/views/newAccount_views/AddDriver&Bus_view.dart';
import 'package:busify_gerant/views/node_views/StopLocation_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class StopsSelector extends StatefulWidget {

  final Map<String, dynamic> data;
  const StopsSelector({required this.data});

  @override
  State<StopsSelector> createState() => _StopsSelectorState();
}

class _StopsSelectorState extends State<StopsSelector> {
  
  NodeController nodeRepo = NodeController();


  List<Node>? arrets; //= widget.data["nodes"];
  List<bool>? isChecked ; // List<bool>.filled(arrets.length, false);
  bool all = false;

  @override
  void initState() {
    super.initState();
    arrets = widget.data["nodes"];
    isChecked = List<bool>.filled(arrets!.length, false);
  }
 
  
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
  
    // List<Node> arrets = widget.data["nodes"];
    
    

    return Scaffold(
      appBar: AppBar(
        title: const Text("Selection des arrets"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: SizedBox(
          width: width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 25, 25, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Selectionnez les arrets que vous voulez. Cliquez sur l'icone position de l'arret pour voir son emplacement sur la carte.",
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 5,),

                Padding(
                  padding: const EdgeInsets.only(right: 9),
                  child: CheckboxListTile(
                    title: Text(
                      "Selectionner tout",
                      style: Theme.of(context).textTheme.bodySmall
                    ),
                    value: all, 
                    onChanged: (value){
                      setState(() {
                        all = !all;
                        for (int i = 0; i < isChecked!.length; i++) {
                          isChecked![i] = all;
                        }
                        
                      });
                      
                    }
                  ),
                ),

                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: arrets!.length,
                  itemBuilder: (context, index){
                    return Card(
                      child: ListTile(
                        title: Text(
                          arrets![index].name,
                          style: Theme.of(context).textTheme.bodyMedium
                        ),
                        subtitle: Text(
                          "ID : ${arrets![index].id.toString()}",
                           style: Theme.of(context).textTheme.bodySmall
                        ),
                        leading: IconButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => StopLocation(arret: arrets![index]))
                            );
                          },
                          icon: const Icon(
                            CupertinoIcons.location_solid,
                            color: Colors.blue,
                          ),
                        ),
                        trailing: Checkbox(
                          value: isChecked![index], 
                          onChanged:(val) {
                            print("Berfore $index = ${isChecked![index]}");
                            setState(
                              () {
                                isChecked![index] = val!;
                              },
                            );
                            print("After $index = ${isChecked![index]}");
                          },
                        ),
                      ),
                    );
                  }
                ),

                

                const SizedBox(height: 35,),

                CupertinoButton(
                  color: Theme.of(context).primaryColor,
                  child: const Text('Continer'),
                  onPressed: () {
                    print("Continer");

                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => AddDriverAndBus(data: widget.data))
                    );

                  },
                ),

                const SizedBox(height: 25,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}