class Cliente {
  String dni;
  String nombre;
  String contacto;

  Cliente({
    required this.dni,
    required this.nombre,
    required this.contacto,
  });
}

List<Cliente> clientes = [
  Cliente(dni: '12345678', nombre: 'Carlos Ruiz', contacto: '987654321'),
  Cliente(dni: '23456789', nombre: 'Ana Torres', contacto: '987654322'),
  Cliente(dni: '34567890', nombre: 'Luis Miguel', contacto: '987654323'),
  Cliente(dni: '45678901', nombre: 'María López', contacto: '987654324'),
];
