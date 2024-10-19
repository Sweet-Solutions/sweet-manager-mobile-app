class Proveedor {
  String nombre;
  String contacto;
  String direccion;
  String producto;

  Proveedor({
    required this.nombre,
    required this.contacto,
    required this.direccion,
    required this.producto,
  });
}

List<Proveedor> proveedores = [
  Proveedor(nombre: 'Juan Salgado', contacto: '997215124', direccion: 'Av Lirios', producto: 'Producto 1'),
  Proveedor(nombre: 'Max Rodas', contacto: '957213124', direccion: 'Calle Brisas', producto: 'Producto 2'),
  Proveedor(nombre: 'Nico Pasos', contacto: '912321212', direccion: 'Calle Flores', producto: 'Producto 3'),
  Proveedor(nombre: 'Chaco Perez', contacto: '961234567', direccion: 'Av Palmeras', producto: 'Producto 4'),
];
