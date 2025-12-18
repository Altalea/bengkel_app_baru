class TransactionModel {
  final int? id;
  final String customerName; // Nama Pelanggan
  final String mechanicName; // Mekanik yang mengerjakan
  final String date;         // Tanggal (misal: 19-12-2025)
  final String items;        // Barang yg dibeli (misal: "Oli, Kampas Rem")
  final double totalPrice;   // Total Rupiah

  TransactionModel({
    this.id,
    required this.customerName,
    required this.mechanicName,
    required this.date,
    required this.items,
    required this.totalPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'mechanicName': mechanicName,
      'date': date,
      'items': items,
      'totalPrice': totalPrice,
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
    );
  }
}