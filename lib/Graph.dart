import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_util/date_util.dart';

class Graph extends StatefulWidget {
  final firebaseInstance;
  Graph(this.firebaseInstance);
  @override
  _GraphState createState() => _GraphState(firebaseInstance);
}

class _GraphState extends State<Graph> {
  int _selectedItemPosition = 0;
  final firebaseInstance;
  _GraphState(this.firebaseInstance);
  var _start;
  var _end;
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime utc = DateTime.utc(now.year, now.month, now.day);
    switch (_selectedItemPosition) {
      case 1:
        var endDay = DateUtils.getDaysInMonth(now.year, now.month);
        DateTime utcStart = DateTime.utc(now.year, now.month, 1);
        DateTime utcEnd = DateTime.utc(now.year, now.month, endDay);
        _start = Timestamp.fromMillisecondsSinceEpoch(
            utcStart.add(Duration(hours: -7)).millisecondsSinceEpoch);
        _end = Timestamp.fromMillisecondsSinceEpoch(utcEnd
            .add(Duration(hours: 16, minutes: 59, seconds: 59))
            .millisecondsSinceEpoch);
        break;
      case 2:
        DateTime utcStart = DateTime.utc(now.year, 1, 1);
        DateTime utcEnd = DateTime.utc(now.year, 12, 31);
        _start = Timestamp.fromMillisecondsSinceEpoch(
            utcStart.add(Duration(hours: -7)).millisecondsSinceEpoch);
        _end = Timestamp.fromMillisecondsSinceEpoch(utcEnd
            .add(Duration(hours: 16, minutes: 59, seconds: 59))
            .millisecondsSinceEpoch);
        break;
      default:
        _start = Timestamp.fromMillisecondsSinceEpoch(
            utc.add(Duration(hours: -7)).millisecondsSinceEpoch);
        _end = Timestamp.fromMillisecondsSinceEpoch(utc
            .add(Duration(hours: 16, minutes: 59, seconds: 59))
            .millisecondsSinceEpoch);
        break;
    }
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;
    return Stack(children: [
      Center(
        child: Container(
          width: _screenWidth * 0.85,
          height: _screenHeight * 0.53,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: Colors.white,
          ),
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 65),
                child: Card(firebaseInstance, _start, _end),
              ),
            ],
          ),
        ),
      ),
      SnakeNavigationBar.color(
        height: 30,
        behaviour: SnakeBarBehaviour.floating,
        padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
        snakeViewColor: Color(0xff8C35B1),
        snakeShape: SnakeShape.rectangle,
        currentIndex: _selectedItemPosition,
        onTap: (index) => setState(() => _selectedItemPosition = index),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        items: [
          BottomNavigationBarItem(
              icon: Text(
            "Day",
            style: TextStyle(
              color:
                  _selectedItemPosition == 0 ? Colors.white : Color(0xff8C35B1),
              fontSize: 16,
            ),
          )),
          BottomNavigationBarItem(
            icon: Text("Month",
                style: TextStyle(
                  color: _selectedItemPosition == 1
                      ? Colors.white
                      : Color(0xff8C35B1),
                  fontSize: 16,
                )),
          ),
          BottomNavigationBarItem(
              icon: Text("Year",
                  style: TextStyle(
                    color: _selectedItemPosition == 2
                        ? Colors.white
                        : Color(0xff8C35B1),
                    fontSize: 16,
                  ))),
        ],
      ),
    ]);
  }
}

class Card extends StatelessWidget {
  final firebaseInstance;
  final _start;
  final _end;
  Card(this.firebaseInstance, this._start, this._end);
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser.uid;
    final user = FirebaseFirestore.instance.collection('users').doc(uid);
    return StreamBuilder<QuerySnapshot>(
        stream: user
            .collection('wallet')
            .document(firebaseInstance.walletID.toString())
            .collection('transaction')
            .orderBy('createdOn', descending: true)
            .startAt([_end]).endAt([_start]).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Text('');
          }
          int len = snapshot.data.documents.length;
          double incomeNumber = 0;
          double expenseNumber = 0;
          for (var i = 0; i < len; i++) {
            DocumentSnapshot trans = snapshot.data.documents[i];
            if (trans['cost'] > 0) {
              incomeNumber += trans['cost'];
            } else {
              expenseNumber += trans['cost'];
            }
          }
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(2),
                    height: 48,
                    width: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.16),
                          spreadRadius: 1.0,
                          blurRadius: 3.5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Income",
                          style:
                              TextStyle(color: Color(0xff3FD371), fontSize: 11),
                        ),
                        Text(
                          incomeNumber.toStringAsFixed(2),
                          style:
                              TextStyle(color: Color(0xff3FD371), fontSize: 11),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.all(2),
                    height: 48,
                    width: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.16),
                          spreadRadius: 1.0,
                          blurRadius: 3.5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Expense",
                          style:
                              TextStyle(color: Color(0xffCB3F3F), fontSize: 11),
                        ),
                        Text(
                          expenseNumber.toStringAsFixed(2),
                          style:
                              TextStyle(color: Color(0xffCB3F3F), fontSize: 11),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                (incomeNumber + expenseNumber) > 0
                    ? "Change : +" +
                        (incomeNumber + expenseNumber).toStringAsFixed(2)
                    : "Change : " +
                        (incomeNumber + expenseNumber).toStringAsFixed(2),
                style: TextStyle(color: Color(0xffA1A1A1), fontSize: 11),
              ),
            ],
          );
        });
  }
}
