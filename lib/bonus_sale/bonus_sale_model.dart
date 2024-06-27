class BonusSale {
  final String salesId;
  final int period;
  final int penjualan;
  final int payment;
  final int totalCommission;
  final String details;

  BonusSale(
      {required this.salesId,
      required this.period,
      required this.penjualan,
      required this.payment,
      required this.totalCommission,
      required this.details});

  Map<String, dynamic> toMap() {
    return {
      'salesId': salesId,
      'period': period,
      'penjualan': penjualan,
      'payment': payment,
      'totalComission': totalCommission,
      'details': details
    };
  }

  static BonusSale fromMap(Map<String, dynamic> map) {
    return BonusSale(
        salesId: map['salesId'],
        period: map['period'],
        penjualan: map['penjualan'],
        payment: map['payment'],
        totalCommission: map['totalCommission'],
        details: map['details']);
  }
}
