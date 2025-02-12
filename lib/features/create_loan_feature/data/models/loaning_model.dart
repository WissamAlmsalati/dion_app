class LoaningModel {
  final String deptName;
  final String phoneNumber;
  final double amount;
  final String dueDate;
  final String notes;
  final int loanType;

  LoaningModel({
    required this.deptName,
    required this.phoneNumber,
    required this.amount,
    required this.dueDate,
    required this.notes,
    required this.loanType,
  });

  Map<String, dynamic> toJson() {
    return {
      'deptName': deptName,
      'phoneNumber': phoneNumber,
      'amount': amount,
      'dueDate': "2024-11-24T10:19:31.057Z",
      'notes': notes,
      'loanType': loanType,
    };
  }
}