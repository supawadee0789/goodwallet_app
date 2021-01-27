import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodwallet_app/components/Header.dart';
import 'package:goodwallet_app/components/Manual_income_component.dart';
import 'package:goodwallet_app/components/Manual_expense_component.dart';
import 'package:goodwallet_app/components/Manual_transfer_component.dart';

class ManualIncome extends StatefulWidget {
  final _walletID;
  ManualIncome(this._walletID);
  @override
  _ManualIncomeState createState() => _ManualIncomeState(_walletID);
}

class _ManualIncomeState extends State<ManualIncome> {
  bool income = true;
  bool expense = false;
  bool transfer = false;
  var incomeOpacity = 1.0;
  var expenseOpacity = 0.0;
  var transferOpacity = 0.0;
  final _walletID;
  _ManualIncomeState(this._walletID);
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffAE90F4), Color(0xffDF8D9F)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Header(),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.05,
                      horizontal: MediaQuery.of(context).size.width * 0.08),
                  alignment: Alignment.topCenter,
                  height: _screenHeight * 0.85,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.elliptical(200, 60))),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                income = true;
                                expense = false;
                                transfer = false;
                                incomeOpacity = 1.0;
                                expenseOpacity = 0.0;
                                transferOpacity = 0.0;
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.23,
                              height:
                                  MediaQuery.of(context).size.height * 0.045,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color:
                                    income ? Color(0xffB58FE7) : Colors.white,
                                border: Border.all(color: Color(0xffB58FE7)),
                              ),
                              child: Center(
                                child: Text(
                                  'Income',
                                  style: TextStyle(
                                      color: income
                                          ? Colors.white
                                          : Color(0xffB58FE7),
                                      fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                income = false;
                                expense = true;
                                transfer = false;
                                incomeOpacity = 0.0;
                                expenseOpacity = 1.0;
                                transferOpacity = 0.0;
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.23,
                              height:
                                  MediaQuery.of(context).size.height * 0.045,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color:
                                    expense ? Color(0xffB58FE7) : Colors.white,
                                border: Border.all(color: Color(0xffB58FE7)),
                              ),
                              child: Center(
                                child: Text(
                                  'Expense',
                                  style: TextStyle(
                                      color: expense
                                          ? Colors.white
                                          : Color(0xffB58FE7),
                                      fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                income = false;
                                expense = false;
                                transfer = true;
                                incomeOpacity = 0.0;
                                expenseOpacity = 0.0;
                                transferOpacity = 1.0;
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.23,
                              height:
                                  MediaQuery.of(context).size.height * 0.045,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color:
                                    transfer ? Color(0xffB58FE7) : Colors.white,
                                border: Border.all(color: Color(0xffB58FE7)),
                              ),
                              child: Center(
                                child: Text(
                                  'Transfer',
                                  style: TextStyle(
                                      color: transfer
                                          ? Colors.white
                                          : Color(0xffB58FE7),
                                      fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: _screenHeight * 0.05),
                      Stack(
                        children: [
                          IgnorePointer(
                            ignoring: !income,
                            child: AnimatedOpacity(
                              child: IncomeComponent(_walletID),
                              opacity: incomeOpacity,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.linear,
                            ),
                          ),
                          IgnorePointer(
                            ignoring: !expense,
                            child: AnimatedOpacity(
                              child: ExpenseComponent(_walletID),
                              opacity: expenseOpacity,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.linear,
                            ),
                          ),
                          IgnorePointer(
                            ignoring: !transfer,
                            child: AnimatedOpacity(
                              child: TransferComponent(_walletID),
                              opacity: transferOpacity,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.linear,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class TypeButton extends StatefulWidget {
//   @override
//   _TypeButtonState createState() => _TypeButtonState();
// }
//
// class _TypeButtonState extends State<TypeButton> {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               income = true;
//               expense = false;
//               transfer = false;
//               incomeOpacity = 1.0;
//               expenseOpacity = 0.0;
//               transferOpacity = 0.0;
//             });
//           },
//           child: Container(
//             width: MediaQuery.of(context).size.width * 0.23,
//             height: MediaQuery.of(context).size.height * 0.045,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(20)),
//               color: income ? Color(0xffB58FE7) : Colors.white,
//               border: Border.all(color: Color(0xffB58FE7)),
//             ),
//             child: Center(
//               child: Text(
//                 'Income',
//                 style: TextStyle(
//                     color: income ? Colors.white : Color(0xffB58FE7),
//                     fontSize: 16),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         ),
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               income = false;
//               expense = true;
//               transfer = false;
//               incomeOpacity = 0.0;
//               expenseOpacity = 1.0;
//               transferOpacity = 0.0;
//             });
//           },
//           child: Container(
//             width: MediaQuery.of(context).size.width * 0.23,
//             height: MediaQuery.of(context).size.height * 0.045,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(20)),
//               color: expense ? Color(0xffB58FE7) : Colors.white,
//               border: Border.all(color: Color(0xffB58FE7)),
//             ),
//             child: Center(
//               child: Text(
//                 'Expense',
//                 style: TextStyle(
//                     color: expense ? Colors.white : Color(0xffB58FE7),
//                     fontSize: 16),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         ),
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               income = false;
//               expense = false;
//               transfer = true;
//               incomeOpacity = 0.0;
//               expenseOpacity = 0.0;
//               transferOpacity = 1.0;
//             });
//           },
//           child: Container(
//             width: MediaQuery.of(context).size.width * 0.23,
//             height: MediaQuery.of(context).size.height * 0.045,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(20)),
//               color: transfer ? Color(0xffB58FE7) : Colors.white,
//               border: Border.all(color: Color(0xffB58FE7)),
//             ),
//             child: Center(
//               child: Text(
//                 'Transfer',
//                 style: TextStyle(
//                     color: transfer ? Colors.white : Color(0xffB58FE7),
//                     fontSize: 16),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
