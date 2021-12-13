import 'package:flutter/material.dart';

BankingData bankingData = BankingData(<BankingEntry>[
  BankingEntry('Groceries', 483, Icons.free_breakfast, Colors.red),
  BankingEntry('Tourism', 346, Icons.map, Colors.blue),
  BankingEntry('Shopping', 120, Icons.shopping_cart, Colors.green),
  BankingEntry('Transport', 137, Icons.directions_car, Colors.purple),
]);

class BankingData {
  int totalSpent;
  final List<BankingEntry> entries;
  List<double> entryPercentages;
  List<double> sectionStartPercentages;

  BankingData(this.entries) {
    totalSpent = _calculateTotalSpent(entries);
    entryPercentages = _calculateEntryPercentages(entries, totalSpent);
    sectionStartPercentages = _calculateSectionStartPercentages(entryPercentages);
  }

  int _calculateTotalSpent(List<BankingEntry> entries) {
    return entries.map((entry) => entry.amount).fold(0, (total, entry) => total + entry);
  }

  List<double> _calculateEntryPercentages(List<BankingEntry> entries, int totalSpent) {
    return entries.map((entry) => entry.amount / totalSpent).toList();
  }

  List<double> _calculateSectionStartPercentages(List<double> entriesPercentages) {
    double runningTotal = 0;
    final List<double> offsets = [];
    for (double p in entriesPercentages) {
      offsets.add(runningTotal);
      runningTotal += p;
      print('runningTotal: $runningTotal');
    }
    offsets.add(1);
    sectionStartPercentages = offsets;
    return offsets;
  }
}

class BankingEntry {
  final String label;
  final int amount;
  final IconData icon;
  final MaterialColor color;

  BankingEntry(this.label, this.amount, this.icon, this.color);
}
