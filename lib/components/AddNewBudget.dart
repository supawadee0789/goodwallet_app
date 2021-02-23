import 'package:flutter/material.dart';

class AddNewBudget extends StatefulWidget {
  @override
  _AddNewBudgetState createState() => _AddNewBudgetState();
}

class _AddNewBudgetState extends State<AddNewBudget> {
  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: _screenHeight * 0.2,
      color: Colors.white,
    );
  }
}
