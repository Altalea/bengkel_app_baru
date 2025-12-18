class TransactionModel {
  final int? id;
  final String customerName;
  final String mechanicName;
  final String date;
  final String items;
  final double totalPrice;
  final String status; // BARU: Menunggu, Proses, Selesai

  TransactionModel({
    this.id,
    required this.customerName,
    required this.mechanicName,
    required this.date,
    required this.items,
    required this.totalPrice,
    required this.status, // Wajib diisi
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'mechanicName': mechanicName,
      'date': date,
      'items': items,
      'totalPrice': totalPrice,
      'status': status,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      customerName: map['customerName'],
      mechanicName: map['mechanicName'],
      date: map['date'],
      items: map['items'],
      totalPrice: map['totalPrice'],
      status: map['status'] ?? 'Menunggu', // Default kalau null
    );
  }

  // Helper untuk duplikasi objek dengan data baru (untuk update status)
  TransactionModel copyWith({int? id, String? customerName, String? mechanicName, String? date, String? items, double? totalPrice, String? status}) {
    return TransactionModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      mechanicName: mechanicName ?? this.mechanicName,
      date: date ?? this.date,
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
    );
  }
}