class Package {
  final int? id;
  final String name;       // Nama Barang/Jasa
  final double price;      // Harga
  final String type;       // Jenis: 'Servis' atau 'Sparepart'
  final String? description; // Keterangan

  Package({
    this.id,
    required this.name,
    required this.price,
    required this.type,
    this.description,
  });

  // Convert ke Map (untuk simpan ke Database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'type': type,
      'description': description,
    };
  }

  // Convert dari Map (untuk ambil dari Database)
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