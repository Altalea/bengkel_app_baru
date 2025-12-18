class Customer {
  final int? id;
  final String name;
  final String mobile;
  final String email;
  final String address;
  final String vehicleNumber; // KHUSUS: Plat Nomor Kendaraan

  Customer({
    this.id,
    required this.name,
    required this.mobile,
    required this.email,
    required this.address,
    required this.vehicleNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'email': email,
      'address': address,
      'vehicleNumber': vehicleNumber,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      mobile: map['mobile'],
      email: map['email'],
      address: map['address'],
      vehicleNumber: map['vehicleNumber'],
    );
  }
}