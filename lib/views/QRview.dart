import 'dart:convert';

import 'package:busify_gerant/utils/PDFGeneration/PDFGeneration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRView extends StatefulWidget {

  final Map<String, dynamic> data; 
  const QRView({required this.data});

  @override
  State<QRView> createState() => _QRViewState();
}

class _QRViewState extends State<QRView> {

  


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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  SizedBox(
                    width: 150,
                    height: 150,
                    child: Image.asset('assets/gerant.png'),
                  ),

                  const SizedBox(height: 15,),

                  Text(
                    "Voici le code QR de votre Bus, vous pouvez telecharger ce code en format PDF.",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.justify,
                  ), 

                  const SizedBox(height: 15,),

                  SizedBox(
                    width: width*0.75,
                    height: width*0.75,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: QrImage(
                          foregroundColor: Colors.black,
                          data: jsonEncode(widget.data)
                        ),
                      ),
                    ),

                  ),
                  
                  const SizedBox(height: 25,),

                  CupertinoButton(
                    color: Theme.of(context).primaryColor,
                    child: const Text("Telecharger"),
                    onPressed: (){
                      writhsmth(jsonEncode(widget.data));
                    }
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