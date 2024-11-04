class Provider{
  int id;
  String name;
  String address;
  String email;
  int phone;
  String state;

  Provider({
    required this.id,
    required this.name,
    required this.address,
    required this.email,
    required this.phone,
    required this.state

  });

  factory Provider.fromJson(Map<String, dynamic>json){
    return Provider(
      id: json['id'],
      name : json ['name'],
      address: json ['address'],
      email: json ['email'],
      phone: json ['phone'],
      state: json ['state'],
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'name' : name,
      'address' : address,
      'email' : email,
      'phone' : phone,
      'state' : state,
    };
  }

}