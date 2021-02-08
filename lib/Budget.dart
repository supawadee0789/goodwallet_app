import 'package:flutter/material.dart';

class Budget extends StatefulWidget {
  @override
  _BudgetState createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {
  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        width: _screenWidth * 0.85,
        height: _screenHeight * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Colors.red,
        ),
        child: Center(child: Text("This is Budget. \nfor test transition")),
      ),
    );
  }
}
