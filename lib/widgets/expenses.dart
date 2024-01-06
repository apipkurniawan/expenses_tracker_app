import 'package:expenses_tracker_flutter_app/widgets/chart/chart.dart';
import 'package:expenses_tracker_flutter_app/widgets/expenses_list/expenses_list.dart';
import 'package:expenses_tracker_flutter_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expenses_tracker_flutter_app/models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      amount: 10.00,
      date: DateTime.now(),
      title: "Flutter",
      category: Category.work,
    ),
    Expense(
      amount: 21.00,
      date: DateTime.now(),
      title: "Cinema",
      category: Category.leisure,
    )
  ];

  void _saveExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _openAddExpensesOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true, // set to full modal
        context: context,
        builder: (ctx) {
          return NewExpense(onAddExpense: _saveExpense);
        });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Expense Deleted!"),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(child: Text("No Expenses Found!"));

    if (_registeredExpenses.isNotEmpty) {
      mainContent = Expanded(
          child: ExpensesList(
        expenses: _registeredExpenses,
        onRemove: _removeExpense,
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Expenses"),
        actions: [
          IconButton(
            onPressed: _openAddExpensesOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                mainContent,
              ],
            )
          : Row(
              children: [
                Chart(expenses: _registeredExpenses),
                mainContent,
              ],
            ),
    );
  }
}
