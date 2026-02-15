import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyProvider with ChangeNotifier {
  String _currency = 'INR';

  String get currency => _currency;

  CurrencyProvider() {
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    _currency = prefs.getString('currency') ?? 'INR';
    notifyListeners();
  }

  Future<void> setCurrency(String code) async {
    _currency = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', code);
    notifyListeners();
  }
}
