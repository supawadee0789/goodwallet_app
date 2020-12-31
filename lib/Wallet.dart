import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:goodwallet_app/AddWallet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'CreateWallet.dart';

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          //Background Gradient Color
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffAE90F4), Color(0xffDF8D9F)],
            ),
          ),
          child: Column(
            children: [
              HeaderWallet(),
              TotalCard(),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 30, bottom: 50),
                  child: WalletList(),
                  width: MediaQuery.of(context).size.width * 0.83,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AddWallet();
                  }));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.078,
                  decoration: BoxDecoration(
                      color: Color(0xffE5A9B6),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(23),
                          topRight: Radius.circular(23))),
                  child: Center(
                    child: Text(
                      "Add new wallet",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
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

class HeaderWallet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 17, 22.5, 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => {},
            icon: Icon(
              Icons.account_circle_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            "WALLET",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 25, letterSpacing: 0.66),
          ),
          Container(
            child: Row(
              children: [
                IconButton(
                  onPressed: () => {},
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                IconButton(
                  onPressed: () => {},
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TotalCard extends StatelessWidget {
  @override
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  double money = 0;
  getTotal() {
    return fetchTotal().then((value) {
      money = value;
      return value;
    }).catchError((error) => throw (error));
  }

  Future<double> fetchTotal() async {
    double money = 0;
    await for (var snapshot
        in Firestore.instance.collection('wallet').snapshots()) {
      for (var wallet in snapshot.documents) {
        final cost = wallet.get('money');
        money = money + cost;
      }
      return money;
    }
  }

  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80,
      height: MediaQuery.of(context).size.height * 0.198,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(34)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              "TOTAL",
              style: TextStyle(
                  color: Color(0xffA1A1A1),
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
          FutureBuilder(
            future: getTotal(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                getTotal();
                return Text('0');
              } else {
                return Container(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 300.0,
                      maxHeight: 100.0,
                    ),
                    child: AutoSizeText(
                      money.toStringAsFixed(2).replaceAllMapped(reg, mathFunc),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 41.0,
                          color: Color(0xffA890FE),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "BAHT",
              style: TextStyle(
                  color: Color(0xffA890FE),
                  fontSize: 14,
                  letterSpacing: 0.42,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class WalletList extends StatelessWidget {
  @override
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  Widget build(BuildContext context) {
    Query wallets = FirebaseFirestore.instance
        .collection('wallet')
        .orderBy('createdOn', descending: false);

    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: wallets.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot wallet = snapshot.data.documents[index];
              return Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return new CreateWallet(index);
                    }));
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.096,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 7),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            wallet['name'],
                            style: TextStyle(
                                color: Color(0xffA1A1A1),
                                fontSize: 20,
                                decoration: TextDecoration.none),
                          ),
                          Text(
                            wallet['money']
                                .toStringAsFixed(2)
                                .replaceAllMapped(reg, mathFunc),
                            style: TextStyle(
                                color: Color(0xffA890FE),
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none),
                          )
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(34),
                      color: Colors.white,
                    ),
                  ),
                ),
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: 'Delete',
                    icon: Icons.delete,
                    foregroundColor: Colors.white,
                    color: Color(0x00000000),
                    onTap: () async {
                      await wallet.reference.delete();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return new Wallet();
                      }));
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}