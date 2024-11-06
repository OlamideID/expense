import 'dart:convert';

import 'package:expense/model/expense.dart';
import 'package:expense/new_expense.dart';
import 'package:expense/widgets/expenses_list/expenses_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final expensesJson =
        jsonEncode(_registeredExpenses.map((e) => e.toJson()).toList());
    await prefs.setString('expenses', expensesJson);
  }

  Future<void> _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final expensesJson = prefs.getString('expenses');
    if (expensesJson != null) {
      final List<dynamic> decodedList = jsonDecode(expensesJson);
      setState(() {
        _registeredExpenses.clear();
        _registeredExpenses.addAll(decodedList.map((e) => Expense.fromJson(e)));
      });
    }
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
      _saveExpenses();
    });
  }

  void _editExpense(Expense expense, int index) {
    setState(() {
      _registeredExpenses[index] = expense;
      _saveExpenses();
    });
  }

  void _removeExpense(Expense expense) {
    setState(() {
      _registeredExpenses.remove(expense);
      _saveExpenses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        centerTitle: true,
      ),
      body: ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
        onEditExpense: (expense) {
          final index = _registeredExpenses.indexOf(expense);
          _showAddOrEditExpense(context, expense, index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () => _showAddOrEditExpense(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddOrEditExpense(BuildContext context,
      [Expense? expense, int? index]) {
    showModalBottomSheet(
      enableDrag: true,
      useSafeArea: true,
      context: context,
      isScrollControlled:
          true, // Allows you to control the size of the bottom sheet
      builder: (ctx) => SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height, // Fills the screen
          child: NewExpense(
            initialExpense: expense,
            onSaveExpense: (newExpense) {
              if (index != null) {
                _editExpense(newExpense, index);
              } else {
                _addExpense(newExpense);
              }
              Navigator.of(ctx).pop();
            },
          ),
        ),
      ),
    );
  }
}
