class RadioBase3G {
  int? id;
  String nombre;
  String psc;

  RadioBase3G({
    this.id,
    required this.nombre,
    required this.psc,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'psc': psc,
    };
  }

  factory RadioBase3G.fromMap(Map<String, dynamic> map) {
    return RadioBase3G(
      id: map['id'],
      nombre: map['nombre'],
      psc: map['psc'],
    );
  }
}