class Bus {
  final String name;
  final String marque; 
  final String matricule;

  Bus(this.name, this.marque, this.matricule);

  toJson(Bus bus){
    return {
      "nom" : bus.name,
      "marque" : bus.marque,
      "matricule" : bus.matricule,
    };
  }

  factory Bus.fromJson(Map<String, dynamic> json){
    return Bus(
      json["nom"], 
      json["marque"], 
      json["matricule"] 
    );
  }

  @override
  String toString() {
    return "nom = $name, marque = $marque, matricule = $matricule ";
  }
}