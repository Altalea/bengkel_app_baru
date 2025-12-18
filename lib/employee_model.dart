class Employee {
  final int? id;
  final String name;
  final String position;
  final String phone;
  final String imagePath;
  final String password; // BARU

  Employee({
    this.id,
    required this.name,
    required this.position,
    required this.phone,
    required this.imagePath,
    required this.password, // Wajib
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'phone': phone,
      'imagePath': imagePath,
      'password': password,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      position: map['position'],
      phone: map['phone'],
      imagePath: map['imagePath'] ?? '',
      password: map['password'] ?? '123456',
    );
  }
}