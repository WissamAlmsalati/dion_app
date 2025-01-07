// lib/models/loaning_data.dart
class LoaningData {
  final double totalSettledDebts;
  final int lendersCount;
  final double totalSettledDebtors;
  final int borrowersCount;

  LoaningData({
    required this.totalSettledDebts,
    required this.lendersCount,
    required this.totalSettledDebtors,
    required this.borrowersCount,
  });

  factory LoaningData.fromJson(Map<String, dynamic> json) {
    return LoaningData(
      totalSettledDebts: json['totalSettledDebts'],
      lendersCount: json['lendersCount'],
      totalSettledDebtors: json['totalSettledDebtors'],
      borrowersCount: json['borrowersCount'],
    );
  }
}