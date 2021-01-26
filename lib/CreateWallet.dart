import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:goodwallet_app/HistoryPage.dart';
import 'package:goodwallet_app/Wallet.dart';
import 'package:goodwallet_app/components/Header.dart';
import 'package:goodwallet_app/components/TransactionList.dart';
import 'package:goodwallet_app/components/WalletCard.dart';
import 'package:goodwallet_app/components/BottomBar.dart';

// show wallet list
class CreateWallet extends StatefulWidget {
  final firebaseInstance;
  CreateWallet(this.firebaseInstance);
  @override
  _CreateWalletState createState() => _CreateWalletState(firebaseInstance);
}

class _CreateWalletState extends State<CreateWallet> {
  final firebaseInstance;
  _CreateWalletState(this.firebaseInstance);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: firebaseInstance.wallets.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError &&
                snapshot.data.docs[firebaseInstance.walletIndex] == null) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            DocumentSnapshot wallet =
                snapshot.data.docs[firebaseInstance.walletIndex];
            return ThisWallet(
                wallet['name'], wallet['money'], wallet.id, firebaseInstance);
          }),
    );
  }
}

class ThisWallet extends StatefulWidget {
  final firebaseInstance;
  final String name;
  final money;
  final index;

  ThisWallet(this.name, this.money, this.index, this.firebaseInstance);

  @override
  _ThisWalletState createState() => _ThisWalletState(
      this.name, this.money, this.index, this.firebaseInstance);
}

class _ThisWalletState extends State<ThisWallet> {
  final firebaseInstance;
  final String name;
  final money;
  final index;
  _ThisWalletState(this.name, this.money, this.index, this.firebaseInstance);

  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffAE90F4), Color(0xffDF8D9F)],
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Header(),
            WalletCard(widget.name, widget.money),
            SizedBox(height: 8),
            Container(
              width: _screenWidth * 0.85,
              height: _screenHeight * 0.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: Color.fromRGBO(255, 255, 255, 0.66)),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(23, 19, 0, 0),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Today List",
                      style: TextStyle(
                        color: Color(0xff8C35B1),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TransList(firebaseInstance.walletID, firebaseInstance),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return new History(
                            firebaseInstance.walletID, firebaseInstance);
                      }));
                    },
                    child: Container(
                      // margin: EdgeInsets.only(top: _screenHeight * 0.01),

                      child: Text(
                        "Today List",
                        style: TextStyle(
                          color: Color(0xff8C35B1),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    TransList(index),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return new History(index);
                        }));
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: _screenHeight * 0.01),
                        child: Text(
                          "see more",
                          style: TextStyle(
                            color: Color(0xff8C35B1),
                            decoration: TextDecoration.underline,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                  )
                ],
              ),
            ),
            BottomBar(widget.index, widget.firebaseInstance),
          ],
        ),
      ),
    );
  }
}
