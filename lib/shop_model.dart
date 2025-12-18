class Shop {
  final int? id;
  final String shopName;
  final String address;
  final String ownerName;
  final String type;
  final String? imagePath; // Tambahan: Untuk simpan lokasi foto

  Shop({
    this.id,
    required this.shopName,
    required this.address,
    required this.ownerName,
    required this.type,
    this.imagePath,
  });

  // Convert ke Map (Simpan ke DB)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shopName': shopName,
      'address': address,
      'ownerName': ownerName,
      'type': type,
      'imagePath': imagePath, // Jangan lupa simpan ini
    };
  }

  // Convert dari Map (Ambil dari DB)
  factory Shop.fromMap(Map<String, dynamic> map) {
    return Shop(
      id: map['id'],
      shopName: map['shopName'],
      address: map['address'],
      ownerName: map['ownerName'],
      type: map['type'],
      imagePath: map['imagePath'],
    );
  }
}