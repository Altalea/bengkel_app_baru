class Package {
  final int? id;
  final String name;
  final double price;
  final String type;
  final String? description;

  Package({this.id, required this.name, required this.price, required this.type, this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'type': type,
      'description': description,
    };
  }

  factory Package.fromMap(Map<String, dynamic> map) {
    return Package(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      type: map['type'],
      description: map['description'],
    );
  }
}