import 'package:expense/new_expense.dart';
import 'package:expense/widgets/chart/chart.dart';
import 'package:expense/widgets/expenses_list/expenses_list.dart';
import 'package:flutter/material.dart';
import 'model/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        category: Category.leisure,
        title: 'Flutter Course',
        amount: 19.99,
        date: DateTime.now()),
    Expense(
        category: Category.work,
        title: 'Java Course',
        amount: 15.69,
        date: DateTime.now())
  ];


  // Method to calculate total expenses
  double get totalExpenses {
    return _registeredExpenses.fold(
        0.0, (sum, expense) => sum + expense.amount);
  }

  _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
      ),
    );
  }

  _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Deleted'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('Add an expense and see the Magic'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.blue[900],
        centerTitle: true,
        title: const Text(
          'EXPENSE TRACKER',
        ),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      //backgroundColor: Colors.grey[300],
      body: width < 600
          ? Column(
              children: [

                Chart(expenses: _registeredExpenses),

                const SizedBox(height: 10,),
                Text(
                  'Total Expenses: \$${totalExpenses.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10,),


                Expanded(child: mainContent),
        ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registeredExpenses)),
                Expanded(child: mainContent),
              ],
            ),
    );
  }
}
