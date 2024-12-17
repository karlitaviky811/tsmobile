class Tabulator {
  int id;
  String n;
  String linea;
  String gama;
  String producto;
  String? familia;
  String repuestos;
  String costosServicios;
  DateTime createdAt;
  DateTime updatedAt;

  Tabulator({
    required this.id,
    required this.n,
    required this.linea,
    required this.gama,
    required this.producto,
    this.familia,
    required this.repuestos,
    required this.costosServicios,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Tabulator.fromJson(Map<String, dynamic> json) {
    return Tabulator(
      id: json['id'],
      n: json['n'],
      linea: json['linea'],
      gama: json['gama'],
      producto: json['producto'],
      familia: json['familia'],
      repuestos: json['repuestos'],
      costosServicios: json['costos_servicios'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
