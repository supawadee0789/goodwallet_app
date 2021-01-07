import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TransList extends StatelessWidget {
  final index;
  TransList(this.index);
  final wallets = FirebaseFirestore.instance;
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: wallets
              .collection('wallet')
              .document(index)
              .collection('transaction')
              .orderBy('createdOn', descending: false)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            return Container(
              width: screenWidth * 311 / 360,
              height: screenHeight * 290 / 760,
              child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot trans = snapshot.data.documents[index];
                    var time = DateFormat.yMMMd()
                        .add_jm()
                        .format(DateTime.parse(
                            trans['createdOn'].toDate().toString()))
                        .split(" ");
                    return Container(
                        margin: EdgeInsets.fromLTRB(
                            15 / 360 * screenWidth,
                            5 / 760 * screenHeight,
                            15 / 360 * screenWidth,
                            5 / 760 * screenHeight),
                        height: screenHeight * 66 / 760,
                        width: screenWidth * 281 / 360,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 14 / 360 * screenWidth,
                                        right: 10 / 360 * screenWidth),
                                    child: Icon(
                                      Icons.add_photo_alternate,
                                      color: Color(0xffC88EC5),
                                      size: 40 /
                                          (360 * 760) *
                                          (screenHeight * screenWidth),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        trans['name'],
                                        style: TextStyle(
                                            fontFamily: 'Knit',
                                            color: Color(0xff6A2388),
                                            fontSize: 15 /
                                                (760 * 360) *
                                                (screenHeight * screenWidth),
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(height: 2 / 760 * screenHeight),
                                      Text(
                                        time[3] + " " + time[4],
                                        style: TextStyle(
                                            color: Color(0xffBCBCBC),
                                            fontSize: 11),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 17.0),
                              child: Text(
                                "฿ " +
                                    trans['cost']
                                        .toStringAsFixed(2)
                                        .replaceAllMapped(reg, mathFunc),
                                style: TextStyle(
                                    color: Color(0xff6A2388),
                                    fontSize: 15 /
                                        (760 * 360) *
                                        (screenHeight * screenWidth),
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ));
                  }),
            );
          }),
    );
  }
}
