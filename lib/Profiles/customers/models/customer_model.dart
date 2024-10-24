class Customer {
  String idNumber;
  String name;
  String contact;

  Customer({
    required this.idNumber,
    required this.name,
    required this.contact,
  });
}

List<Customer> customers = [
  Customer(idNumber: '12345678', name: 'Carlos Ruiz', contact: '987654321'),
  Customer(idNumber: '23456789', name: 'Ana Torres', contact: '987654322'),
  Customer(idNumber: '34567890', name: 'Luis Miguel', contact: '987654323'),
  Customer(idNumber: '45678901', name: 'María López', contact: '987654324'),
];
