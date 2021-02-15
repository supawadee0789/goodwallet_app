import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodwallet_app/components/Header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Wallet.dart';

class AddWallet extends StatefulWidget {
  @override
  _AddWalletState createState() => _AddWalletState();
}

class _AddWalletState extends State<AddWallet> {
  final _fireStore = Firestore.instance;
  final uid = FirebaseAuth.instance.currentUser.uid;
  String name = "";
  double money = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffAE90F4), Color(0xffDF8D9F)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Header(),
              Container(
                height: 252,
                width: MediaQuery.of(context).size.width * 0.68,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(34),
                    color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 214,
                      child: TextField(
                        decoration: new InputDecoration(
                            hintText: "wallet name",
                            hintStyle: TextStyle(
                                color: Color(0xffA1A1A1), fontSize: 22)),
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 22, color: Color(0xffA1A1A1)),
                        onChanged: (String str) {
                          setState(() {
                            name = str;
                          });
                        },
                      ),
                    ),
                    TextField(
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          hintText: "0",
                          hintStyle: TextStyle(
                              color: Color(0xffB58FE7), fontSize: 50)),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xffB58FE7), fontSize: 50),
                      onChanged: (String n) {
                        setState(() {
                          money = double.parse(n);
                        });
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 25),
                      child: Text("BAHT",
                          style: TextStyle(
                            color: Color(0xffB58FE7),
                            fontSize: 16,
                          )),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  _fireStore
                      .collection('users')
                      .doc(uid)
                      .collection('wallet')
                      .add({
                    'name': name,
                    'money': money,
                    'createdOn': Timestamp.now(),
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  height: 51,
                  width: MediaQuery.of(context).size.width * 0.68,
                  margin: EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(31),
                      color: Color(0xff6A2388)),
                  child: Center(
                    child: Text(
                      "Add new wallet",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w100),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
