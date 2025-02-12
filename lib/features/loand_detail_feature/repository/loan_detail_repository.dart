import 'package:dion_app/features/loans_list/data/models/loan.dart';

abstract class LoanDetailRepository {
  Future<Loan> fetchLoanDetail({
    required int loanId,
  });
}
