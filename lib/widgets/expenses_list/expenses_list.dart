import 'package:expense/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

import '../../model/expense.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.onRemoveExpense});

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (ctx, index) => Dismissible(
            background: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10)
              ),
              margin: EdgeInsets.symmetric(
                  horizontal: Theme.of(context).cardTheme.margin!.horizontal),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            key: ValueKey(
              expenses[index],
            ),
            onDismissed: (direction) {
              onRemoveExpense(expenses[index]);
            },
            child: ExpenseItem(expense: expenses[index])));
  }
}
