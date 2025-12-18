class Supplier {
  final int? id;
  final String name;
  final String mobile;
  final String email;
  final String address;
  final String category; // Misal: Sparepart, Oli, Ban

  Supplier({
    this.id,
    required this.name,
    required this.mobile,
    required this.email,
    required this.address,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'email': email,
      'address': address,
      'category': category,
    };
  }

  factory Supplier.fromMap(Map<String, dynamic> map) {
    return Supplier(
      id: map['id'],
      name: map['name'],
      mobile: map['mobile'],
      email: map['email'],
      address: map['address'],
      category: map['category'],
    );
  }
}