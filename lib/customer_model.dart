class Customer {
  final int? id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String vehicleNumber;
  final String password; // BARU

  Customer({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.vehicleNumber,
    required this.password, // Wajib
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'vehicleNumber': vehicleNumber,
      'password': password,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'] ?? '-',
      address: map['address'],
      vehicleNumber: map['vehicleNumber'] ?? '-',
      password: map['password'] ?? '123456', // Default kalau data lama kosong
    );
  }
}