import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:goodwallet_app/HistoryPage.dart';
import 'package:goodwallet_app/components/Header.dart';
import 'package:goodwallet_app/components/TransactionList.dart';
import 'package:goodwallet_app/components/WalletCard.dart';
import 'package:goodwallet_app/components/BottomBar.dart';

class CreateWallet extends StatefulWidget {
  final arg;
  CreateWallet(this.arg);
  @override
  _CreateWalletState createState() => _CreateWalletState(arg);
}

class _CreateWalletState extends State<CreateWallet> {
  final arg;
  _CreateWalletState(this.arg);
  @override
  Widget build(BuildContext context) {
    Query wallets = FirebaseFirestore.instance
        .collection('wallet')
        .orderBy('createdOn', descending: false);
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: wallets.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError && snapshot.data.docs[arg] == null) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            DocumentSnapshot wallet = snapshot.data.docs[arg];
            return ThisWallet(wallet['name'], wallet['money'], wallet.id);
          }),
    );
  }
}

class ThisWallet extends StatelessWidget {
  final String name;
  final money;
  final index;
  ThisWallet(this.name, this.money, this.index);

  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
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
            WalletCard(name, money),
            SizedBox(height: 8),
            Container(
              width: _screenWidth * 0.8,
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
                  TransList(index),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return new History(index);
                      }));
                    },
                    child: Text(
                      "see more",
                      style: TextStyle(
                        color: Color(0xff8C35B1),
                        decoration: TextDecoration.underline,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BottomBar(),
          ],
        ),
      ),
    ));
  }
}
