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
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.42,
              child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot trans = snapshot.data.documents[index];
                    return Container(
                        margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        height: MediaQuery.of(context).size.height * 0.09,
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
                                    padding: const EdgeInsets.only(
                                        left: 22, right: 14),
                                    child: Icon(
                                      Icons.add_photo_alternate,
                                      color: Color(0xffC88EC5),
                                      size: 40,
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
                                            color: Color(0xff6A2388),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        DateFormat.yMMMd()
                                            .add_jm()
                                            .format(DateTime.parse(
                                                trans['createdOn']
                                                    .toDate()
                                                    .toString()))
                                            .substring(13, 20),
                                        // DateTime.parse(
                                        //         trans['createdOn'].toString())
                                        //     .toString()
                                        //     .toString(),
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
                                    fontSize: 18,
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