import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Budget extends StatefulWidget {
  @override
  _BudgetState createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {
  OverlayEntry overlayEntry;
  var _height;
  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;
    _height = _screenHeight;
    return Center(
      child: Container(
        width: _screenWidth * 0.85,
        height: _screenHeight * 0.5,
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
            Container(
              height: _screenHeight * 0.1,
              width: double.infinity,
              padding: EdgeInsets.all(_screenWidth * 0.05),
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                  color: Colors.white),
              child: GestureDetector(
                onTap: budgetDialog,
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
                        style:
                            TextStyle(color: Color(0xffEA8D8D), fontSize: 20),
                      ),
                    )
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
        context: context,
        builder: (BuildContext context) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50),
            padding: EdgeInsets.all(20),
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
                Align(
                  alignment: Alignment.topRight,
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
            ]),
          );
        });
  }
}
