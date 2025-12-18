class Employee {
  final int? id;
  final String name;
  final String position; // Misal: Mekanik Senior, Kasir, dll
  final String phone;
  final String? imagePath; // Tambahan untuk foto

  Employee({
    this.id,
    required this.name,
    required this.position,
    required this.phone,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'phone': phone,
      'imagePath': imagePath,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      position: map['position'],
      phone: map['phone'],
      imagePath: map['imagePath'],
    );
  }
}