import 'dart:math';

enum LoanType { given, taken }

class Loan {
  final int? id;
  final String title;
  final double amount;
  final double interestRate; // Annual interest rate in %
  final int tenureMonths;
  final LoanType type;
  final DateTime startDate;
  final double emiAmount;
  final double amountPaid;
  final bool isClosed;
  final String? notes;

  Loan({
    this.id,
    required this.title,
    required this.amount,
    required this.interestRate,
    required this.tenureMonths,
    required this.type,
    required this.startDate,
    required this.emiAmount,
    this.amountPaid = 0.0,
    this.isClosed = false,
    this.notes,
  });

  // Calculate EMI: [P x R x (1+R)^N]/[(1+R)^N-1]
  // P = Principal, R = Monthly Interest Rate, N = Tenure in Months
  static double calculateEMI(double principal, double annualRate, int months) {
    if (annualRate == 0) return principal / months;
    double monthlyRate = annualRate / 12 / 100;
    return (principal * monthlyRate * pow(1 + monthlyRate, months)) /
        (pow(1 + monthlyRate, months) - 1);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'interestRate': interestRate,
      'tenureMonths': tenureMonths,
      'type': type.index,
      'startDate': startDate.toIso8601String(),
      'emiAmount': emiAmount,
      'amountPaid': amountPaid,
      'isClosed': isClosed ? 1 : 0,
      'notes': notes,
    };
  }

  static Loan fromMap(Map<String, dynamic> map) {
    return Loan(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      interestRate: map['interestRate'],
      tenureMonths: map['tenureMonths'],
      type: LoanType.values[map['type']],
      startDate: DateTime.parse(map['startDate']),
      emiAmount: map['emiAmount'],
      amountPaid: map['amountPaid'],
      isClosed: map['isClosed'] == 1,
      notes: map['notes'],
    );
  }
}
