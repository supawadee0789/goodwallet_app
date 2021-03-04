import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<Map> sumExpClass(firebaseInstance, budget) async {
  final fireStore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser.uid;

  Map<String, double> exp = {};
  for (var expClass in budget['BudgetClass']) {
    double sum = 0;
    try {
      QuerySnapshot snapshot = await fireStore
          .collection('users')
          .doc(uid)
          .collection('wallet')
          .doc(firebaseInstance.walletID.toString())
          .collection('transaction')
          .where('class', isEqualTo: expClass)
          .getDocuments();
      for (var i = 0; i < snapshot.docs.length; i++) {
        DocumentSnapshot data = snapshot.docs[i];
        sum += data['cost'];
      }
    } catch (e) {
      return null;
    }
    exp[expClass] = sum;
  }

  return exp;
}
