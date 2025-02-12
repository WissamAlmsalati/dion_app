class Loan {
  final int id;
  final String deptName;
  final String phoneNumber;
  final int creditorId;
  final int debtorId;
  final double amount;
  final double refundAmount;
  final DateTime dueDate;
  final String notes;
  final DateTime updatedAt;
  final String loanStatus; // Changed from int to String
  final int loanType;
  // Optionally, you may parse creditor/debtor objects if they exist.
  
  Loan({
    required this.id,
    required this.deptName,
    required this.phoneNumber,
    required this.creditorId,
    required this.debtorId,
    required this.amount,
    required this.refundAmount,
    required this.dueDate,
    required this.notes,
    required this.updatedAt,
    required this.loanStatus,
    required this.loanType,
  });
  
  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json['id'] ?? 0,
      deptName: json['deptName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      creditorId: json['creditorId'] ?? 0,
      debtorId: json['debtorId'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
      refundAmount: (json['refundAmount'] ?? 0).toDouble(),
      dueDate: DateTime.parse(json['dueDate']),
      notes: json['notes'] ?? '',
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      loanStatus: json['loanStatus'] ?? '',
      loanType: json['loanType'] ?? 0,
    );
  }
}
