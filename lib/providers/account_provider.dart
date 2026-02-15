import 'package:flutter/material.dart';
import '../models/account.dart';
import '../services/database_service.dart';

class AccountProvider with ChangeNotifier {
  List<Account> _accounts = [];
  final DatabaseService _dbService = DatabaseService();

  List<Account> get accounts => _accounts;

  Future<void> fetchAccounts() async {
    _accounts = await _dbService.getAccounts();
    notifyListeners();
  }

  double get totalBalance =>
      _accounts.fold(0.0, (sum, item) => sum + item.balance);

  Future<void> addAccount(Account account) async {
    await _dbService.insertAccount(account);
    await fetchAccounts();
  }

  Future<void> initAccounts() async {
    await fetchAccounts();
    if (_accounts.isEmpty) {
      // Seed default account
      await _dbService.insertAccount(
        Account(name: 'Cash', type: AccountType.cash, balance: 0.0),
      );
      await fetchAccounts();
    }
  }

  Future<void> updateAccount(Account account) async {
    await _dbService.updateAccount(account);
    await fetchAccounts();
  }

  Future<void> deleteAccount(int id) async {
    await _dbService.deleteAccount(id);
    await fetchAccounts();
  }
}
