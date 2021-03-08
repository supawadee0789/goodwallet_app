import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodwallet_app/components/BudgetComponent.dart';
import 'package:goodwallet_app/components/Manual_expense_component.dart';
import 'package:menu_button/menu_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goodwallet_app/classes/SearchClassForBudget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Budget extends StatefulWidget {
  final firebaseInstance;
  Budget(this.firebaseInstance);
  @override
  _BudgetState createState() => _BudgetState(firebaseInstance);
}

class _BudgetState extends State<Budget> {
  final firebaseInstance;
  _BudgetState(this.firebaseInstance);
  var _height;
  final _fireStore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser.uid;
  var _screenHeight;
  var _screenWidth;

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;
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
            new Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _fireStore
                    .collection('users')
                    .doc(uid)
                    .collection('wallet')
                    .doc(firebaseInstance.walletID.toString())
                    .collection('budget')
                    .orderBy('CreatedOn', descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: Text("Loading..."));
                  }
                  var len = snapshot.data.documents.length;
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: len,
                            itemBuilder: (context, index) {
                              DocumentSnapshot budget =
                                  snapshot.data.documents[index];
                              return Slidable(
                                actionPane: SlidableScrollActionPane(),
                                actionExtentRatio: 0.25,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minHeight: _screenHeight * 66 / 760),
                                  child:
                                      BudgetComponent(budget, firebaseInstance),
                                ),
                                secondaryActions: [
                                  IconSlideAction(
                                    caption: 'Delete',
                                    icon: Icons.delete,
                                    foregroundColor: Colors.white,
                                    color: Color(0x000000),
                                    onTap: () {
                                      budget.reference.delete();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    },
                                  ),
                                ],
                              );
                            }),
                        GestureDetector(
                          onTap: budgetDialog,
                          child: Container(
                            height: _screenHeight * 0.1,
                            width: double.infinity,
                            padding: EdgeInsets.all(_screenWidth * 0.05),
                            margin: EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(13)),
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  final snackBar = SnackBar(
    content: Text(
      'Budget has been deleted.',
      style: TextStyle(fontSize: 12),
    ),
  );

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
                AddNewBudget(firebaseInstance)
              ]),
            ),
          );
        });
  }
}

class AddNewBudget extends StatefulWidget {
  final firebaseInstance;
  AddNewBudget(this.firebaseInstance);
  @override
  _AddNewBudgetState createState() => _AddNewBudgetState(firebaseInstance);
}

class _AddNewBudgetState extends State<AddNewBudget> {
  final firebaseInstance;
  _AddNewBudgetState(this.firebaseInstance);
  final uid = FirebaseAuth.instance.currentUser.uid;
  final _fireStore = FirebaseFirestore.instance;
  var recurrence = 'Daily';
  String budgetName = '';
  double amount = 0.0;
  Map<String, bool> classSelected = {
    'entertainment': false,
    'residence': false,
    'household': false,
    'travel': false,
    'health': false,
    'food': false,
    'shopping': false
  };
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
                budgetName = str;
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
                amount = double.parse(str);
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
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        classSelected['entertainment'] =
                            !classSelected['entertainment'];
                      });
                    },
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 100),
                      opacity: classSelected['entertainment'] ? 1 : 0.5,
                      child: expenseClass('Entertainment', 'Entertainment',
                          color: 0xffEA8D8D),
                    ),
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        classSelected['residence'] =
                            !classSelected['residence'];
                      });
                    },
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 100),
                      opacity: classSelected['residence'] ? 1 : 0.5,
                      child: expenseClass('Residence', 'Residence',
                          color: 0xffEA8D8D),
                    ),
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        classSelected['household'] =
                            !classSelected['household'];
                      });
                    },
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 100),
                      opacity: classSelected['household'] ? 1 : 0.5,
                      child: expenseClass('Household', 'Household',
                          color: 0xffEA8D8D),
                    ),
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        classSelected['travel'] = !classSelected['travel'];
                      });
                    },
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 100),
                      opacity: classSelected['travel'] ? 1 : 0.5,
                      child:
                          expenseClass('Travel', 'Travel', color: 0xffEA8D8D),
                    ),
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        classSelected['health'] = !classSelected['health'];
                      });
                    },
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 100),
                      opacity: classSelected['health'] ? 1 : 0.5,
                      child:
                          expenseClass('Health', 'Health', color: 0xffEA8D8D),
                    ),
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        classSelected['food'] = !classSelected['food'];
                      });
                    },
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 100),
                      opacity: classSelected['food'] ? 1 : 0.5,
                      child: expenseClass('Food', 'Food', color: 0xffEA8D8D),
                    ),
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        classSelected['shopping'] = !classSelected['shopping'];
                      });
                    },
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 100),
                      opacity: classSelected['shopping'] ? 1 : 0.5,
                      child: expenseClass('Shopping', 'Shopping',
                          color: 0xffEA8D8D),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
            menuButtonBackgroundColor: Color(0),
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
            items: ["Daily", "Weekly", "Monthly", "Yearly"],
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
            onTap: () {
              print(budgetName + ' ' + amount.toString() + recurrence);
              print(classSelected.keys
                  .where((element) => classSelected[element] == true));
              var budgetClass = classSelected.keys
                  .where((element) => classSelected[element] == true)
                  .toList();
              _fireStore
                  .collection('users')
                  .doc(uid)
                  .collection('wallet')
                  .doc(firebaseInstance.walletID.toString())
                  .collection('budget')
                  .add({
                'BudgetName': budgetName,
                'Amount': amount,
                'BudgetClass': budgetClass,
                'CreatedOn': FieldValue.serverTimestamp(),
                'Recurrence': recurrence,
              });
              Navigator.pop(context);
            },
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
