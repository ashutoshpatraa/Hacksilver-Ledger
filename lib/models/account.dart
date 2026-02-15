enum AccountType { cash, bank, creditCard, other }

class Account {
  final int? id;
  final String name;
  final AccountType type;
  final double balance; // Current balance

  Account({
    this.id,
    required this.name,
    required this.type,
    required this.balance,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'type': type.index, 'balance': balance};
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      name: map['name'],
      type: AccountType.values[map['type']],
      balance: map['balance'],
    );
  }
}
