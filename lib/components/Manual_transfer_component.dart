import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:menu_button/menu_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goodwallet_app/components/walletSelector.dart';
import 'package:goodwallet_app/classes/classes.dart';

class TransferComponent extends StatefulWidget {
  final _walletID;
  TransferComponent(this._walletID);
  @override
  _TransferComponentState createState() => _TransferComponentState(_walletID);
}

class _TransferComponentState extends State<TransferComponent> {
  final _walletID;
  String note;
  double amount;
  final _fireStore = Firestore.instance;
  var initialWallet;
  var targetWallet;
  _TransferComponentState(this._walletID);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialWallet = new Transactions();
    targetWallet = new Transactions();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Column(
                  children: [
                    Text(
                      "From",
                      style: TextStyle(color: Color(0xffA890FE), fontSize: 16),
                    ),
                    WalletSelector(initialWallet),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: SvgPicture.asset(
                  "./images/transferLogo.svg",
                  color: Color(0xffA890FE),
                  width: 25,
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      "To",
                      style: TextStyle(color: Color(0xffA890FE), fontSize: 16),
                    ),
                    WalletSelector(targetWallet),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 40),
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
              //initial wallet
              _fireStore
                  .collection('wallet')
                  .document(initialWallet.targetWalletID)
                  .collection('transaction')
                  .add({
                'class': 'transfer',
                'cost': -amount ?? 0,
                'createdOn': FieldValue.serverTimestamp(),
                'name': note,
                'type': 'transfer'
              });

              //target wallet
              _fireStore
                  .collection('wallet')
                  .document(targetWallet.targetWalletID)
                  .collection('transaction')
                  .add({
                'class': 'transfer',
                'cost': amount ?? 0,
                'createdOn': FieldValue.serverTimestamp(),
                'name': note,
                'type': 'transfer'
              });

              //update wallet
              CollectionReference wallet =
                  FirebaseFirestore.instance.collection('wallet');
              wallet
                  .doc(initialWallet.targetWalletID.toString())
                  .update({'money': FieldValue.increment(-amount)})
                  .then((value) => print("Wallet Updated"))
                  .catchError(
                      (error) => print("Failed to update wallet: $error"));

              wallet
                  .doc(targetWallet.targetWalletID.toString())
                  .update({'money': FieldValue.increment(amount)})
                  .then((value) => print("Wallet Updated"))
                  .catchError(
                      (error) => print("Failed to update wallet: $error"));

              // navigate back
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
          ),
        ],
      ),
    );
  }
}
