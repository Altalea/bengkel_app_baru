class Supplier {
  final int? id;
  final String name;
  final String phone;
  final String email;     // Baru
  final String address;
  final String category;  // Baru (Misal: Oli, Ban, Sparepart)

  Supplier({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'category': category,
    };
  }

  factory Supplier.fromMap(Map<String, dynamic> map) {
    return Supplier(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'] ?? '-',
      address: map['address'],
      category: map['category'] ?? '-',
    );
  }
}