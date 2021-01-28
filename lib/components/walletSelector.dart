import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:menu_button/menu_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WalletSelector extends StatefulWidget {
  final currentTransaction;
  WalletSelector(this.currentTransaction);
  @override
  _WalletSelectorState createState() =>
      _WalletSelectorState(currentTransaction);
}

class _WalletSelectorState extends State<WalletSelector> {
  // ignore: deprecated_member_use
  final currentTransaction;
  _WalletSelectorState(this.currentTransaction);

  final wallets = Firestore.instance;
  var selectedItem = '';
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: wallets
            .collection('wallet')
            .orderBy('createdOn', descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List listWallet = [];
          List listWalletID = [];
          for (var n in snapshot.data.docs) {
            listWallet.add(n['name']);
            listWalletID.add(n.id);
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
                var idIndex = listWallet.indexOf(value);
                var idValue = listWalletID[idIndex];
                currentTransaction.setTargetWallet(value, idValue);
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
