import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:goodwallet_app/components/Header.dart';
import 'package:goodwallet_app/components/TransactionList.dart';
import 'package:goodwallet_app/components/WalletCard.dart';

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
          children: [
            Header(),
            WalletCard(name, money),
            SizedBox(height: 18),
            TransList(index),
          ],
        ),
      ),
    ));
  }
}
