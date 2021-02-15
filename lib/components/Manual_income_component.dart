import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class IncomeComponent extends StatefulWidget {
  final _walletID;
  IncomeComponent(this._walletID);
  @override
  _IncomeComponentState createState() => _IncomeComponentState(_walletID);
}

class _IncomeComponentState extends State<IncomeComponent> {
  final _fireStore = Firestore.instance;
  final uid = FirebaseAuth.instance.currentUser.uid;
  final _walletID;
  _IncomeComponentState(this._walletID);
  double amount = 0;
  String note = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Amount",
                style: TextStyle(color: Color(0xffB58FE7), fontSize: 16),
                textAlign: TextAlign.left),
          ),
          TextField(
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
          SizedBox(height: 40),
          GestureDetector(
            onTap: () {
              _fireStore
                  .collection('users')
                  .doc(uid)
                  .collection('wallet')
                  .document(_walletID)
                  .collection('transaction')
                  .add({
                'class': 'income',
                'cost': amount ?? 0,
                'createdOn': FieldValue.serverTimestamp(),
                'name': note,
                'type': 'income'
              });

              CollectionReference wallet = FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('wallet');
              wallet
                  .doc(_walletID)
                  .update({'money': FieldValue.increment(amount)})
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
        ],
      ),
    );
  }
}
