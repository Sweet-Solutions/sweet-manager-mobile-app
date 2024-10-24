class Report{
  int id; 
  int typesReportsId;
  int adminsId;
  int workersId;
  String fileUrl;
  String title;
  String description;

  Report({required this.id, required this.typesReportsId, 
  required this.adminsId, required this.workersId, 
  required this.fileUrl, required this.title, required this.description});
}

//hacer un dropdown con los tipos de reportes
//chequear los ids del type reports


// prox semana: añadirle firebase 
// flutterfire 