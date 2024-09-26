class Supplyrequest{ 
  int id;
  int paymentOwnersId;
  int suppliesId;
  int count;
  double amount; 

  Supplyrequest({
    required this.id,
    required this.paymentOwnersId,
    required this.suppliesId,
    required this.count,
    required this.amount,
  });
}