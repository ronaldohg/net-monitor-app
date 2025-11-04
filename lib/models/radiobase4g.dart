class RadioBase4G {
  int? id;
  String nombre;
  String ci;

  RadioBase4G({
    this.id,
    required this.nombre,
    required this.ci,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'ci': ci,
    };
  }

  factory RadioBase4G.fromMap(Map<String, dynamic> map) {
    return RadioBase4G(
      id: map['id'],
      nombre: map['nombre'],
      ci: map['ci'],
    );
  }
}