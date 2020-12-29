import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class WalletCard extends StatelessWidget {
  final String name;
  final money;
  WalletCard(this.name, this.money);
  @override
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
                  name,
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
            ]));
  }
}
