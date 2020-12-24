import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
              Header(),
              TotalCard("Kuy Prayut", 9999999999999.589),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: ListWallet(),
                width: MediaQuery.of(context).size.width * 0.83,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
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
  final String title;
  final money;
  TotalCard(this.title, this.money);
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80,
      height: 160,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(34)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              title,
              style: TextStyle(
                  color: Color(0xffA1A1A1),
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
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

class ListWallet extends StatelessWidget {
  @override
  final List<String> name = <String>['A', 'B', 'C', 'D', 'E', 'F'];
  final List<double> money = <double>[3000, 522000, 4000, 55555, 6033.33, 8.22];
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';
  Widget build(BuildContext context) {
    return SizedBox(
      height: 375,
      child: new ListView.builder(
          scrollDirection: Axis.vertical,
          dragStartBehavior: DragStartBehavior.down,
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: name.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () => print(index),
              child: Container(
                height: 76,
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 7),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name[index],
                        style:
                            TextStyle(color: Color(0xffA1A1A1), fontSize: 20),
                      ),
                      Text(
                        money[index]
                            .toStringAsFixed(2)
                            .replaceAllMapped(reg, mathFunc),
                        style: TextStyle(
                            color: Color(0xffA890FE),
                            fontSize: 32,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34),
                  color: Colors.white,
                ),
              ),
            );
          }),
    );
  }
}
