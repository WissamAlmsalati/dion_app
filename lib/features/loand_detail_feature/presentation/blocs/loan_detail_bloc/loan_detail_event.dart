
abstract class LoanDetailEvent {}

class LoadLoanDetail extends LoanDetailEvent {
  final int loanId;

  LoadLoanDetail({required this.loanId});
}
