import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final formatter = DateFormat('dd/MM/yyyy');
const uuid = Uuid();

enum Category { food, travel, leisure, work, other }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.surfing,
  Category.work: Icons.work,
  Category.other: Icons.emoji_objects
};

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate => formatter.format(date);

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'amount': amount,
        'date': date.toIso8601String(),
        'category': category.toString(),
      };

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        title: json['title'],
        amount: json['amount'],
        date: DateTime.parse(json['date']),
        category: Category.values.firstWhere(
          (e) => e.toString() == json['category'],
          orElse: () => Category.leisure, // Default value if parsing fails
        ),
      );
}

class ExpenseBucket {
  final Category category;
  final List<Expense> expenses;

  double get totalExpenses => expenses.fold(0, (sum, e) => sum + e.amount);

  ExpenseBucket.forCategory(
    this.category,
    List<Expense> allExpenses,
  ) : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  ExpenseBucket({
    required this.category,
    required this.expenses,
  });
}
