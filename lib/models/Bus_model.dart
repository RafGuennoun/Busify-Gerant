class Bus {
  final String name;
  final String marque; 
  final String matricule;
  final String line;

  Bus(this.name, this.marque, this.matricule, this.line);

  toJson(Bus bus){
    return {
      "nom" : bus.name,
      "marque" : bus.marque,
      "matricule" : bus.matricule,
      "line" : bus.line
    };
  }

  factory Bus.fromJson(Map<String, dynamic> json){
    return Bus(
      json["nom"], 
      json["marque"], 
      json["matricule"], 
      json["line"] 
    );
  }

  @override
  String toString() {
    return "nom = $name, marque = $marque, matricule = $matricule, line = $line ";
  }

  String getLine(){
    return line;
  }
}