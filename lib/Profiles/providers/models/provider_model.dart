class Provider {
  String name;
  String contact;
  String address;
  String product;

  Provider({
    required this.name,
    required this.contact,
    required this.address,
    required this.product,
  });
}

List<Provider> providers = [
  Provider(name: 'Juan Salgado', contact: '997215124', address: 'Lirios Ave', product: 'Product 1'),
  Provider(name: 'Max Rodas', contact: '957213124', address: 'Brisas St', product: 'Product 2'),
  Provider(name: 'Nico Pasos', contact: '912321212', address: 'Flores St', product: 'Product 3'),
  Provider(name: 'Chaco Perez', contact: '961234567', address: 'Palmeras Ave', product: 'Product 4'),
];
