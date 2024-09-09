import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final formatter = DateFormat.yMEd();

const uuid = Uuid();

enum Category { food, travel, leisure, work, cruise }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.surfing,
  Category.work: Icons.work,
  Category.cruise: Icons.emoji_people_outlined
};

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }

  Expense(
      {required this.category,
      required this.title,
      required this.amount,
      required this.date})
      : id = uuid.v4();
}

class ExpenseBucket {
  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount;
    }

    return sum;
  }

  ExpenseBucket.forCategory(
    this.category,
    List<Expense> allExpenses,
  ) : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  ExpenseBucket({required this.category, required this.expenses});
}
