class TypesReport {
  final int id;
  final String name;

  TypesReport({required this.id, required this.name});

  // Método para crear una instancia de TypesReport desde un JSON
  factory TypesReport.fromJson(Map<String, dynamic> json) {
    return TypesReport(
      id: json['id'],
      name: json['name'],
    );
  }
}
