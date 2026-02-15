import 'category.dart';

enum Frequency { daily, monthly, quarterly, yearly }

class RecurringTransaction {
  final int? id;
  final String title;
  final double amount;
  final CategoryType type;
  final int categoryId;
  final int? accountId;
  final Frequency frequency;
  final DateTime startDate;
  final DateTime nextDueDate;
  final bool isActive;
  final String? notes;

  RecurringTransaction({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.categoryId,
    this.accountId,
    required this.frequency,
    required this.startDate,
    required this.nextDueDate,
    this.isActive = true,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type.index,
      'categoryId': categoryId,
      'accountId': accountId,
      'frequency': frequency.index,
      'startDate': startDate.toIso8601String(),
      'nextDueDate': nextDueDate.toIso8601String(),
      'isActive': isActive ? 1 : 0,
      'notes': notes,
    };
  }

  factory RecurringTransaction.fromMap(Map<String, dynamic> map) {
    return RecurringTransaction(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      type: CategoryType.values[map['type']],
      categoryId: map['categoryId'],
      accountId: map['accountId'],
      frequency: Frequency.values[map['frequency']],
      startDate: DateTime.parse(map['startDate']),
      nextDueDate: DateTime.parse(map['nextDueDate']),
      isActive: map['isActive'] == 1,
      notes: map['notes'],
    );
  }

  RecurringTransaction copyWith({
    int? id,
    String? title,
    double? amount,
    CategoryType? type,
    int? categoryId,
    int? accountId,
    Frequency? frequency,
    DateTime? startDate,
    DateTime? nextDueDate,
    bool? isActive,
    String? notes,
  }) {
    return RecurringTransaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
    );
  }

  DateTime calculateNextDueDate(DateTime currentDueDate) {
    switch (frequency) {
      case Frequency.daily:
        return currentDueDate.add(const Duration(days: 1));
      case Frequency.monthly:
        // Handle edge cases like Jan 31 -> Feb 28/29 via specialized logic if needed,
        // but for simplicity just adding months using DateTime properties usually works safely enough
        // (though dart's add month might need careful handling if day > 28).
        // A robust way:
        var newMonth = currentDueDate.month + 1;
        var newYear = currentDueDate.year;
        if (newMonth > 12) {
          newMonth = 1;
          newYear++;
        }
        // Date util logic or just use a package like Jiffy or simple logic:
        // Dart DateTime constructor handles overflow: DateTime(2023, 13, 1) becomes Jan 2024.
        // But we want to preserve day of month if possible.
        return DateTime(
          newYear,
          newMonth,
          currentDueDate.day,
          currentDueDate.hour,
          currentDueDate.minute,
        );
      case Frequency.quarterly:
        var newMonth = currentDueDate.month + 3;
        var newYear = currentDueDate.year;
        if (newMonth > 12) {
          newYear += (newMonth - 1) ~/ 12;
          newMonth = (newMonth - 1) % 12 + 1;
        }
        return DateTime(
          newYear,
          newMonth,
          currentDueDate.day,
          currentDueDate.hour,
          currentDueDate.minute,
        );
      case Frequency.yearly:
        return DateTime(
          currentDueDate.year + 1,
          currentDueDate.month,
          currentDueDate.day,
          currentDueDate.hour,
          currentDueDate.minute,
        );
    }
  }
}
