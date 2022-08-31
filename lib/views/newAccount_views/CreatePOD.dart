import 'package:busify_gerant/views/Login_view.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreatePOD extends StatefulWidget {
  const CreatePOD({Key? key}) : super(key: key);

  @override
  State<CreatePOD> createState() => _CreatePODState();
}

class _CreatePODState extends State<CreatePOD> {

  int currentStep = 0;

  final controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.text = "https://pfe-m2-api.herokuapp.com/";
  }
  
  @override
  Widget build(BuildContext context) {
   
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guide'),
        centerTitle: true
      ),

      body: SizedBox(
        width: width,
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            switch (orientation) {
              case Orientation.portrait:
                return _buildStepper(StepperType.vertical, width);
              case Orientation.landscape:
                return _buildStepper(StepperType.horizontal, width);
              default:
                throw UnimplementedError(orientation.toString());
            }
          },
        ),
      ),
    );
  }

  CupertinoStepper _buildStepper(StepperType type, double width) {
    final canCancel = currentStep > 0;
    final canContinue = currentStep < 7;
    return CupertinoStepper(
      type: type,
      currentStep: currentStep,
      onStepTapped: (step) => setState(() => currentStep = step),
      onStepCancel: canCancel ? () => setState(() => --currentStep) : null,
      onStepContinue: currentStep == 6
      ? (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginView())
        );
      }
      : canContinue ? () => setState(() => ++currentStep) : null, 
      steps: [
        for (var i = 0; i < 7; ++i)
          _buildStep(
            width: width,

            title: Text('Etape ${i + 1}'),

            subtitle: i == 0 
            ? const Text('Création du POD')
            : i == 1 
            ? const Text('Création du POD')
            : i == 2 
            ? const Text('Création du POD')
            : i == 3 
            ? const Text('Authentification')
            : i == 4 
            ? const Text('Authentification')
            : i == 5 
            ? const Text('Autorisations')
            : i == 6 
            ? const Text('Autorisations')
            : const Text('Subtitle'),

           exp: i == 0 
            ? "Appuyez sur \n'Register to get a Pod'"
            : i == 1 
            ? "Ajoutez votre nom d'utilisateur"
            : i == 2 
            ? "Ajoutez le reste des infotmations"
            : i == 3 
            ? "Choisissez Solid Community"
            : i == 4 
            ? "Entrez votre nom d'utilisateur et votre mot de passe et appuyez sur \nLog in"
            : i == 5 
            ? "Copiez ce lien"
            : i == 6 
            ? "Donnez toutes les autorisation au lien"
            : "Fin",

            img: i == 0 
            ? "assets/step1.jpg"
            : i == 1 
            ? "assets/step2.jpg"
            : i == 2 
            ? "assets/step3.jpg"
            : i == 3 
            ? "assets/step4.jpg"
            : i == 4  
            ? "assets/step5.jpg"
            : i == 5 
            ? ""
            : i == 6 
            ? "assets/step6.jpg"
            : "",


            isActive: i == currentStep,

            state: i == currentStep
                ? StepState.editing
                : i < currentStep ? StepState.complete : StepState.indexed,
            
          ),
      ],
    );
  }

  Step _buildStep({
    required double width,
    required Widget title,
    required Widget subtitle,
    required String exp,
    String? img,
    StepState state = StepState.indexed,
    bool isActive = false,
  }) {
    return Step(
      title: title,
      subtitle: subtitle,
      state: state,
      isActive: isActive,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          SizedBox(
            child: Center(
              child: Text(
                exp,
                textAlign: TextAlign.center
              ),
            ),
          ),

          const SizedBox(height: 10,),

          img!.isNotEmpty
          ? SizedBox(
            width: width*0.6,
            height: width*0.6,
            child: Image.asset(img)
          ) 
          : Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TextField(
              controller: controller,
              // autofocus: true,
              readOnly: true,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(CupertinoIcons.text_aligncenter),
                labelText: "Lien",
                labelStyle: Theme.of(context).textTheme.bodyMedium,
              ),
              onChanged: null
            ),
          ), 

        ],
      )
    );
  }
}