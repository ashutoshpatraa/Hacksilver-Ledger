import 'package:flutter/foundation.dart';
import '../models/loan.dart';
import '../services/database_service.dart';

class LoanProvider with ChangeNotifier {
  final DatabaseService _databaseService;
  List<Loan> _loans = [];

  LoanProvider(this._databaseService);

  List<Loan> get loans => _loans;

  // Calculate total outstanding amount for loans taken
  double get totalLoansTakenAmount {
    return _loans
        .where((l) => l.type == LoanType.taken && !l.isClosed)
        .fold(0.0, (sum, item) => sum + (item.amount - item.amountPaid));
  }

  // Calculate total outstanding amount for loans given
  double get totalLoansGivenAmount {
    return _loans
        .where((l) => l.type == LoanType.given && !l.isClosed)
        .fold(0.0, (sum, item) => sum + (item.amount - item.amountPaid));
  }

  Future<void> fetchLoans() async {
    _loans = await _databaseService.getLoans();
    notifyListeners();
  }

  Future<void> addLoan(Loan loan) async {
    await _databaseService.insertLoan(loan);
    await fetchLoans();
  }

  Future<void> updateLoan(Loan loan) async {
    await _databaseService.updateLoan(loan);
    await fetchLoans();
  }

  Future<void> deleteLoan(int id) async {
    await _databaseService.deleteLoan(id);
    await fetchLoans();
  }

  // Method to record a payment (this could be enhanced to link with Transactions)
  Future<void> payLoanInstallment(Loan loan, double amount) async {
    final updatedLoan = Loan(
      id: loan.id,
      title: loan.title,
      amount: loan.amount,
      interestRate: loan.interestRate,
      tenureMonths: loan.tenureMonths,
      type: loan.type,
      startDate: loan.startDate,
      emiAmount: loan.emiAmount,
      amountPaid: loan.amountPaid + amount,
      isClosed:
          (loan.amountPaid + amount) >= loan.amount, // Simple closure logic
      notes: loan.notes,
    );
    await updateLoan(updatedLoan);
  }
}
