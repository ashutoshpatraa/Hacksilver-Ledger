import 'category.dart';

class Transaction {
  final int? id;
  final String title;
  final double amount;
  final DateTime date;
  final CategoryType type;
  final int categoryId;
  final int? accountId;
  final int? transferAccountId; // Destination account for transfers
  final String? notes;
  final double? originalAmount;
  final String? originalCurrency;
  final int? loanId;

  Transaction({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.categoryId,
    this.accountId,
    this.transferAccountId,
    this.notes,
    this.originalAmount,
    this.originalCurrency,
    this.loanId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type.index,
      'categoryId': categoryId,
      'accountId': accountId,
      'transferAccountId': transferAccountId,
      'notes': notes,
      'originalAmount': originalAmount,
      'originalCurrency': originalCurrency,
      'loanId': loanId,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      type: CategoryType.values[map['type']],
      categoryId: map['categoryId'],
      accountId: map['accountId'],
      transferAccountId: map['transferAccountId'],
      notes: map['notes'],
      originalAmount: map['originalAmount'],
      originalCurrency: map['originalCurrency'],
      loanId: map['loanId'],
    );
  }
}
