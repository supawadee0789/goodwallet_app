import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransList extends StatelessWidget {
  final index;
  TransList(this.index);
  final wallets = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 398,
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
          Container(
            child: StreamBuilder<QuerySnapshot>(
                stream: wallets
                    .collection('wallet')
                    .document(index)
                    .collection('transaction')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 297,
                    child: ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot trans =
                              snapshot.data.documents[index];
                          return Container(
                            margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                            height: 66,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16)),
                            child: Text(
                              trans['name'],
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }),
                  );
                }),
          )
        ],
      ),
    );
  }
}
