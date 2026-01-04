class Package {
  final int? id;
  final String name;
  final double price;
  final String type;
  final String description; // Kita buat wajib ada isinya (biar gak error null di layar)

  Package({
    this.id,
    required this.name,
    required this.price,
    required this.type,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'type': type,
      'category': type, // Jaga-jaga kalau server butuh field 'category'
      'description': description,
    };
  }

  factory Package.fromMap(Map<String, dynamic> map) {
    return Package(
      id: map['id'],

      // 1. DATA KOSONG DIGANTI DEFAULT (Biar gak crash)
      name: map['name']?.toString() ?? 'Tanpa Nama',

      // 2. JURUS ANTI ERROR HARGA (Paling Penting!)
      // Apapun yang dikirim server (tulisan/angka), paksa jadi Double
      price: double.tryParse(map['price'].toString()) ?? 0.0,

      // 3. FLEXIBLE TYPE
      // Cek apakah server kirim 'type' atau 'category'
      type: map['type']?.toString() ?? map['category']?.toString() ?? 'Servis',

      description: map['description']?.toString() ?? '-',
    );
  }
}