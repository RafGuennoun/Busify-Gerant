import 'package:busify_gerant/models/Node_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class RelationLocations extends StatefulWidget {
  final List<Node> arrets;
  const RelationLocations({required this.arrets});

  @override
  State<RelationLocations> createState() => _RelationLocationsState();
}

class _RelationLocationsState extends State<RelationLocations> {

  MapController? controller ;

  List<GeoPoint> points = [];

  @override
  void initState() {
    super.initState();
    controller = MapController(
      initMapWithUserPosition: false,
      initPosition: GeoPoint(
        latitude: widget.arrets[0].lat, 
        longitude: widget.arrets[0].lon
      ),
    
    );

    for (Node node in widget.arrets) {
      GeoPoint gp = GeoPoint(
        latitude: node.lat, 
        longitude: node.lon
      );

      points.add(gp);
    }

  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
        centerTitle: true,
      ),

      body: Stack(
        children: [

          SizedBox(
            width: width,
            height: height,
            child: OSMFlutter( 
              controller: controller!,
              trackMyPosition: false,
              initZoom: 16,
              minZoomLevel: 14,
              maxZoomLevel: 17,
              stepZoom: 1.0,
              staticPoints: [
                StaticPositionGeoPoint(
                  "Node", 
                  const MarkerIcon(
                    icon: Icon(
                      CupertinoIcons.bus,
                      color: Colors.blue,
                      size: 100,
                    ),
                  ), 
                  points
                )
              ],
            ),
          ),

          Container(
            alignment: Alignment.topCenter,
            height: 80,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection : Axis.horizontal,
              itemCount: widget.arrets.length,
              itemBuilder: (context, index){
                return SizedBox(
                  width: width*0.8,
                  child: Card(
                    child: ListTile(
                      onTap: () {

                        controller!.goToLocation(GeoPoint(
                          latitude: widget.arrets[index].lat, 
                          longitude: widget.arrets[index].lon
                        ));
                      },
                      title: Text(
                        widget.arrets[index].name,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      subtitle: Text(
                        "ID : ${widget.arrets[index].id.toString()}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      leading: Icon(
                        CupertinoIcons.bus,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                  ),
                );
              }
            ),
          )

        ],
      ),

      
    );
  }
}