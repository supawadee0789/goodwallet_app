import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VoiceInput extends StatefulWidget {
  @override
  _VoiceInputState createState() => _VoiceInputState();
}

class _VoiceInputState extends State<VoiceInput> {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 200,
              ),
              Container(
                width: 280,
                child: Text(
                  'Example',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 22),
                ),
              ),
              VoiceExample(),
              VoiceExample(),
              VoiceExample(),
              SizedBox(
                height: 100,
                width: double.infinity,
              ),
              Container(
                child: Text('Press and hold the button\nto record your word',
                    textAlign: TextAlign.center),
              ),
              Container(),
            ],
          ),
        ));
  }
}

class VoiceExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      width: 280,
      margin: EdgeInsets.only(top: 22), //l r 44
      padding: EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color: Colors.white, width: 5.0, style: BorderStyle.solid),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      child: Row(
        children: [
          Container(
            child: SvgPicture.asset('images/transfer.svg'),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              'Income: ได้เงินจากแม่ 200 บาท',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
