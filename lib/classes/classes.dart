import 'package:flutter/material.dart';

class Transactions {
  var tokens;
  var textType;
  String type; // type of transaction eg. income expense transfer
  String _class; // class of transaction eg. health food
  String name; // name of transaction eg. ซื้อข้าวกระเพรา
  var cost; // cost of transaction
  String targetWallet; // target wallet to transfer money
  var targetWalletID;
  // Transaction(this.tokens, this.textType);

  void setTokens(tokens, textType) {
    this.tokens = tokens;
    this.textType = textType;
  }

  void setTargetWallet(target, targetID) {
    this.targetWallet = target;
    this.targetWalletID = targetID;
  }

  void setAllVariables() async {
    print('tokens = ');
    print(this.tokens);
    await this.deleteSpace();
    this.checkType();
    this.checkCost();
    this.checkName();
  }

  void deleteSpace() {
    for (var index = 0; index < this.tokens.length; index++) {
      if (this.textType[index] == 3) {
        this.tokens.removeAt(index);
        this.textType.removeAt(index);
      }
    }
    print(tokens);
  }

  void checkType() {
    var input = this.tokens;
    String _type;
    var income = ['ได้เงิน', 'ได้', 'ได้รับ'];
    var expense = ['ซื้อ', 'จ่าย'];
    var transfer = ['โอน'];

    if (income.any((e) => input.contains(e))) {
      _type = 'Income';
    } else if (expense.any((e) => input.contains(e))) {
      _type = 'Expense';
    } else if (transfer.any((e) => input.contains(e))) {
      _type = 'Transfer';
    } else {
      _type = 'none';
    }
    this.type = _type;
  }

  void checkCost() async {
    var array = this.tokens;
    var costLoc = -1;
    for (var loc = array.length - 1; loc >= 0; loc--) {
      print(array[loc]);
      if (this.textType[loc] == 2) {
        costLoc = loc;
        print('number found!');
        break;
      }
    }
    print(array[costLoc]);
    var localCost = array[costLoc].replaceAll(',', '');
    print(localCost);
    this.cost = double.parse(localCost);
    if (this.type == 'Expense' || this.type == 'Transfer') {
      this.cost = -this.cost;
    }
  }

  void checkName() {
    var array = this.tokens;
    if (this.type == 'Expense') {
      array.removeAt(0);
    }
    print(array);
    for (var i = 0; i < 2; i++) {
      array.removeLast();
      print(array);
    }

    var name = StringBuffer();

    array.forEach((item) {
      name.write(item);
    });
    this.name = name.toString();
    print(this.name);
    print(this.type);
  }
}

bool _isNumeric(String str) {
  if (str == null) {
    return false;
  }
  return double.tryParse(str) != null;
}
