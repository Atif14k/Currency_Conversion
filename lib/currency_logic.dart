import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyLogic {
  Map<String, dynamic>? _eurRates;

  // Fetch the list of currencies
  Future<List<String>?> fetchCurrencyList(BuildContext context) async {
    final url = Uri.parse(
        'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies.json');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data.keys.toList();
      } else {
        _showError(context, 'Failed to load currency list.');
      }
    } catch (e) {
      _showError(context, 'An error occurred while loading currency list.');
    }
    return null;
  }

  // Fetch rates with EUR as the base currency
  Future<Map<String, dynamic>?> fetchEurRates(BuildContext context) async {
    final url = Uri.parse(
        'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/eur.json');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        _eurRates = json.decode(response.body)['eur'];
        return _eurRates;
      } else {
        _showError(context, 'Failed to load EUR rates.');
      }
    } catch (e) {
      _showError(context, 'An error occurred while loading EUR rates.');
    }
    return null;
  }

  // Perform currency conversion
  double? convertCurrency(
      double amount, String fromCurrency, String toCurrency) {
    if (_eurRates == null) return null;

    double fromRate = (_eurRates![fromCurrency] ?? 1).toDouble();
    double toRate = (_eurRates![toCurrency] ?? 1).toDouble();

    return (amount / fromRate) * toRate;
  }

  // Show an error message
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
