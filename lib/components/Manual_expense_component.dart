import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodwallet_app/Wallet.dart';

Widget expenseClass(type, title, {color = 0xff8C35B1}) {
  return Column(
    children: [
      Container(
        height: 33,
        child: SvgPicture.asset(
          './images/$type.svg',
          color: Color(color),
          fit: BoxFit.scaleDown,
        ),
      ),
      SizedBox(height: 3),
      Text(
        title,
        style: TextStyle(color: Color(color), fontSize: 6.5),
      )
    ],
  );
}

class ExpenseComponent extends StatefulWidget {
  final _walletID;
  ExpenseComponent(this._walletID);
  @override
  _ExpenseComponentState createState() => _ExpenseComponentState(_walletID);
}

class _ExpenseComponentState extends State<ExpenseComponent> {
  final _fireStore = Firestore.instance;
  final uid = FirebaseAuth.instance.currentUser.uid;
  int _class;
  final _walletID;
  double amount = 0;
  String note = '';
  _ExpenseComponentState(this._walletID);
  String checkClass(x) {
    String result;
    switch (x) {
      case 1:
        result = 'entertainment';
        break;
      case 2:
        result = 'residence';
        break;
      case 3:
        result = 'household';
        break;
      case 4:
        result = 'travel';
        break;
      case 5:
        result = 'health';
        break;
      case 6:
        result = 'food';
        break;
      case 7:
        result = 'shopping';
        break;
      default:
        result = 'food';
        break;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _class = 1;
                    });
                  },
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: _class == 1 ? 1 : 0.5,
                    child: expenseClass('Entertainment', 'Entertainment'),
                  ),
                ),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _class = 2;
                    });
                  },
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: _class == 2 ? 1 : 0.5,
                    child: expenseClass('Residence', 'Residence'),
                  ),
                ),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _class = 3;
                    });
                  },
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: _class == 3 ? 1 : 0.5,
                    child: expenseClass('Household', 'Household'),
                  ),
                ),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _class = 4;
                    });
                  },
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: _class == 4 ? 1 : 0.5,
                    child: expenseClass('Travel', 'Travel'),
                  ),
                ),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _class = 5;
                    });
                  },
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: _class == 5 ? 1 : 0.5,
                    child: expenseClass('Health', 'Health'),
                  ),
                ),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _class = 6;
                    });
                  },
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: _class == 6 ? 1 : 0.5,
                    child: expenseClass('Food', 'Food'),
                  ),
                ),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _class = 7;
                    });
                  },
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: _class == 7 ? 1 : 0.5,
                    child: expenseClass('Shopping', 'Shopping'),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30),
        Align(
          alignment: Alignment.centerLeft,
          child: Text("Amount",
              style: TextStyle(color: Color(0xffB58FE7), fontSize: 16),
              textAlign: TextAlign.left),
        ),
        TextField(
          maxLength: 7,
          cursorColor: Colors.black,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(22.0)),
              borderSide: BorderSide(color: Color(0xffB58FE7), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(22.0)),
              borderSide: BorderSide(color: Color(0xffB58FE7), width: 1.5),
            ),
          ),
          style: TextStyle(fontSize: 25),
          onChanged: (String str) {
            setState(() {
              amount = double.parse(str);
            });
          },
        ),
        SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Note",
            style: TextStyle(color: Color(0xffC88EC5), fontSize: 16),
          ),
        ),
        TextField(
          cursorColor: Colors.black,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
              borderSide: BorderSide(color: Color(0xffC88EC5), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
              borderSide: BorderSide(color: Color(0xffC88EC5), width: 1.5),
            ),
          ),
          style: TextStyle(fontSize: 20),
          onChanged: (String str) {
            setState(() {
              note = str;
            });
          },
        ),
        SizedBox(height: 30),
        GestureDetector(
          onTap: () {
            _fireStore
                .collection('users')
                .doc(uid)
                .collection('wallet')
                .document(_walletID)
                .collection('transaction')
                .add({
              'class': checkClass(_class),
              'cost': (amount * (-1)) ?? 0,
              'createdOn': FieldValue.serverTimestamp(),
              'name': note,
              'type': 'expense'
            });

            CollectionReference wallet = FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .collection('wallet');
            wallet
                .doc(_walletID)
                .update({'money': FieldValue.increment((amount * (-1)) ?? 0)})
                .then((value) => print("Wallet Updated"))
                .catchError(
                    (error) => print("Failed to update wallet: $error"));
            var counter = 0;
            Navigator.popUntil(context, (route) {
              return counter++ == 2;
            });
          },
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: Color(0xffDB8EA7)),
            child: Center(
              child: Text(
                "ADD NEW TRANSACTION",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
