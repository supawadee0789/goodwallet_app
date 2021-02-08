import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:menu_button/menu_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goodwallet_app/components/walletSelector.dart';
import 'package:goodwallet_app/classes/classes.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

class WalletSelector extends StatefulWidget {
  @override
  _WalletSelectorState createState() => _WalletSelectorState();
}

class _WalletSelectorState extends State<WalletSelector> {
  final wallets = Firestore.instance;
  final uid = FirebaseAuth.instance.currentUser.uid;
  var selectedItem = '';
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: wallets
            .collection('users')
            .doc(uid)
            .collection('wallet')
            .orderBy('createdOn', descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List listWallet = [];
          for (var n in snapshot.data.documents) {
            listWallet.add(n['name']);
          }
          return MenuButton(
            child: SizedBox(
              width: 110,
              height: 40,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 11),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        selectedItem,
                        style: TextStyle(color: Color(0xffA890FE)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                        width: 12,
                        height: 17,
                        child: FittedBox(
                            fit: BoxFit.fill,
                            child: Icon(
                              Icons.arrow_drop_down_rounded,
                              color: Color(0xffA890FE),
                            ))),
                  ],
                ),
              ),
            ), // Widget displayed as the button
            items: listWallet, // List of your items,
            topDivider: true,
            popupHeight:
                180, // This popupHeight is optional. The default height is the size of items
            scrollPhysics:
                AlwaysScrollableScrollPhysics(), // Change the physics of opened menu (example: you can remove or add scroll to menu)
            itemBuilder: (value) => Container(
                width: 83,
                height: 40,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  value,
                  style: TextStyle(color: Color(0xffA890FE)),
                )), // Widget displayed for each item
            toggledChild: Container(
              color: Colors.white,
              child: SizedBox(
                width: 83,
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 11),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          selectedItem,
                          style: TextStyle(color: Color(0xffA890FE)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                          width: 12,
                          height: 17,
                          child: FittedBox(
                              fit: BoxFit.fill,
                              child: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey,
                              ))),
                    ],
                  ),
                ),
              ), // Widget displayed as the button,
            ),
            divider: Container(),
            onItemSelected: (value) {
              setState(() {
                selectedItem = value;
              });
// Action when new item is selected
            },
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24)),
              border: Border.all(color: Color(0xffA890FE), width: 1.5),
              color: Colors.white,
            ),
            onMenuButtonToggle: (isToggle) {},
          );
        });
  }
}
