import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodwallet_app/components/BudgetComponent.dart';
import 'package:goodwallet_app/components/Manual_expense_component.dart';
import 'package:menu_button/menu_button.dart';

class Budget extends StatefulWidget {
  @override
  _BudgetState createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {
  var _height;
  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;
    _height = _screenHeight;
    return Center(
      child: Container(
        width: _screenWidth * 0.85,
        height: _screenHeight * 0.55,
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset('images/money_bag.svg', color: Colors.white),
                SizedBox(width: 10),
                Text(
                  "Budget",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    BudgetComponent(),
                    BudgetComponent(),
                    BudgetComponent(),
                    GestureDetector(
                      onTap: budgetDialog,
                      child: Container(
                        height: _screenHeight * 0.1,
                        width: double.infinity,
                        padding: EdgeInsets.all(_screenWidth * 0.05),
                        margin: EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(13)),
                            color: Colors.white),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Icons.add_box_outlined,
                                color: Color(0xffEA8D8D),
                              ),
                            ),
                            Center(
                              child: Text(
                                "Add New Budget",
                                style: TextStyle(
                                    color: Color(0xffEA8D8D), fontSize: 20),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  budgetDialog() {
    showDialog(
        barrierColor: Colors.white.withOpacity(0),
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              height: _height * 0.75,
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  color: Colors.white),
              child: Column(children: [
                Stack(children: [
                  Center(
                    child: Text("Add New Budget",
                        style: TextStyle(
                            color: Color(0xffEA8D8D),
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'HinSiliguri',
                            decoration: TextDecoration.none)),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      child: Icon(
                        Icons.clear_rounded,
                        color: Color(0xffEA8D8D),
                        size: 30,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ]),
                SizedBox(height: 20),
                AddNewBudget()
              ]),
            ),
          );
        });
  }
}

class AddNewBudget extends StatefulWidget {
  @override
  _AddNewBudgetState createState() => _AddNewBudgetState();
}

class _AddNewBudgetState extends State<AddNewBudget> {
  var recurrence = 'Once';
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0x00000000),
      child: Column(
        children: [
          TextField(
            cursorColor: Colors.black,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  borderSide: BorderSide(color: Color(0xffEA8D8D), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  borderSide: BorderSide(color: Color(0xffEA8D8D), width: 1.5),
                ),
                hintText: "Budget Name...",
                hintStyle: TextStyle(fontSize: 12, color: Color(0xffEA8D8D))),
            style: TextStyle(fontSize: 12, color: Color(0xffEA8D8D)),
            onChanged: (String str) {
              setState(() {
                print(str);
              });
            },
          ),
          SizedBox(height: 15),
          TextField(
            cursorColor: Colors.black,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  borderSide: BorderSide(color: Color(0xffEA8D8D), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  borderSide: BorderSide(color: Color(0xffEA8D8D), width: 1.5),
                ),
                hintText: "Amount...",
                hintStyle: TextStyle(fontSize: 12, color: Color(0xffEA8D8D))),
            style: TextStyle(fontSize: 12, color: Color(0xffEA8D8D)),
            onChanged: (String str) {
              setState(() {
                print(str);
              });
            },
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 17, horizontal: 10),
              child: Text(
                "Select Type Of Budget",
                style: TextStyle(
                    color: Color(0xffEA8D8D),
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SelectClass(),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 17, horizontal: 10),
              child: Text(
                "Recurrence",
                style: TextStyle(
                    color: Color(0xffEA8D8D),
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          MenuButton(
            child: SizedBox(
              height: 40,
              width: double.infinity,
              child: Center(
                child: Text(recurrence,
                    style: TextStyle(color: Color(0xffEA8D8D), fontSize: 16)),
              ),
            ),
            selectedItem: recurrence,
            onItemSelected: (value) {
              setState(() {
                recurrence = value;
              });
            },
            items: ["Once", "Daily", "Weekly", "Monthly", "Yearly"],
            itemBuilder: (value) => Container(
                width: double.infinity,
                height: 35,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  value,
                  style: TextStyle(color: Color(0xffEA8D8D), fontSize: 16),
                )),
            toggledChild: SizedBox(
              height: 40,
              width: double.infinity,
              child: Center(
                child: Text(recurrence,
                    style: TextStyle(color: Color(0xffEA8D8D), fontSize: 16)),
              ),
            ),
            topDivider: false,
            divider: Opacity(
              opacity: 0.2,
              child: Container(
                height: 0.5,
                color: Color(0xffEA8D8D),
              ),
            ),
            onMenuButtonToggle: (value) => null,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24)),
              border: Border.all(color: Color(0xffEA8D8D), width: 1.5),
              color: Colors.white,
            ),
          ),
          SizedBox(height: 50),
          GestureDetector(
            onTap: null,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                  color: Color(0xffEA8D8D),
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: Center(
                  child: Text('Create New Budget',
                      style: TextStyle(fontSize: 16))),
            ),
          )
        ],
      ),
    );
  }
}

class SelectClass extends StatefulWidget {
  @override
  _SelectClassState createState() => _SelectClassState();
}

class _SelectClassState extends State<SelectClass> {
  List<bool> isSelected = List.generate(7, (_) => false);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isSelected[0] = !isSelected[0];
                });
              },
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 100),
                opacity: isSelected[0] ? 1 : 0.5,
                child: expenseClass('Entertainment', 'Entertainment',
                    color: 0xffEA8D8D),
              ),
            ),
          ),
          Flexible(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isSelected[1] = !isSelected[1];
                });
              },
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 100),
                opacity: isSelected[1] ? 1 : 0.5,
                child: expenseClass('Housing', 'Residence', color: 0xffEA8D8D),
              ),
            ),
          ),
          Flexible(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isSelected[2] = !isSelected[2];
                });
              },
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 100),
                opacity: isSelected[2] ? 1 : 0.5,
                child:
                    expenseClass('Household', 'Household', color: 0xffEA8D8D),
              ),
            ),
          ),
          Flexible(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isSelected[3] = !isSelected[3];
                });
              },
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 100),
                opacity: isSelected[3] ? 1 : 0.5,
                child: expenseClass('Travel', 'Travel', color: 0xffEA8D8D),
              ),
            ),
          ),
          Flexible(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isSelected[4] = !isSelected[4];
                });
              },
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 100),
                opacity: isSelected[4] ? 1 : 0.5,
                child: expenseClass('Health', 'Health', color: 0xffEA8D8D),
              ),
            ),
          ),
          Flexible(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isSelected[5] = !isSelected[5];
                });
              },
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 100),
                opacity: isSelected[5] ? 1 : 0.5,
                child: expenseClass('Food', 'Food', color: 0xffEA8D8D),
              ),
            ),
          ),
          Flexible(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isSelected[6] = !isSelected[6];
                });
              },
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 100),
                opacity: isSelected[6] ? 1 : 0.5,
                child: expenseClass('Shopping', 'Shopping', color: 0xffEA8D8D),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
