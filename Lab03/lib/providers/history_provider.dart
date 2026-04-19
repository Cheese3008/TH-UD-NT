import 'package:flutter/material.dart';
import '../models/calculation_history.dart';
import '../services/storage_service.dart';

class HistoryProvider extends ChangeNotifier {
  final StorageService storageService;
  List<CalculationHistory> _items = [];

  HistoryProvider(this.storageService);

  List<CalculationHistory> get items => _items;

  Future<void> loadHistory() async {
    final data = await storageService.loadHistoryJson();
    _items = data.map((e) => CalculationHistory.fromMap(e)).toList();
    notifyListeners();
  }

  Future<void> addHistory(CalculationHistory item) async {
    _items.insert(0, item);
    if (_items.length > 50) {
      _items = _items.take(50).toList();
    }
    await storageService.saveHistoryJson(
      _items.map((e) => e.toMap()).toList(),
    );
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _items = [];
    await storageService.saveHistoryJson([]);
    notifyListeners();
  }
}