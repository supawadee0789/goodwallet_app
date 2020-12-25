import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import "dart:async";

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
                child: Column(
                  children: [
                    Container(
                      width: 280,
                      child: Text(
                        'Example',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                    VoiceExample(
                        'plus', 'รายรับ: ได้เงินจากแม่ 200 บาท', 0xff379243),
                    VoiceExample(
                        'minus', 'รายจ่าย: ซื้อข้าวกะเพรา 45 บาท', 0xffC3374E),
                    VoiceExample('transfer', 'การโอน: โอนเงินไป cash 80 บาท',
                        0xffE1B152),
                  ],
                ),
              ),
              SizedBox(
                height: 102,
                width: double.infinity,
              ),
              Container(
                child: Text(
                  'Press and hold the button\nto record your word',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 23),
                  height: 70,
                  width: 70,
                  child: RadialProgress()),
            ],
          ),
        ));
  }
}

class VoiceExample extends StatelessWidget {
  @override
  final svg;
  final text;
  final color;
  VoiceExample(this.svg, this.text, this.color);

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
            height: 20,
            width: 20,
            child: SvgPicture.asset(
              'images/$svg.svg',
              color: Color(this.color),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              text,
              style: TextStyle(color: Color(this.color), fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}

class RadialProgress extends StatefulWidget {
  final double goalCompleted = 0.0;

  @override
  _RadialProgressState createState() => _RadialProgressState();
}

class _RadialProgressState extends State<RadialProgress>
    with SingleTickerProviderStateMixin {
  AnimationController _radialProgressAnimationController;
  Animation<double> _progressAnimation;
  final Duration fadeInDuration = Duration(milliseconds: 500);
  final Duration fillDuration = Duration(seconds: 2);

  double progressDegrees = 0;
  var count = 0;

  @override
  void initState() {
    super.initState();
    _radialProgressAnimationController =
        AnimationController(vsync: this, duration: fillDuration);
    _progressAnimation = Tween(begin: 0.0, end: 360.0).animate(CurvedAnimation(
        parent: _radialProgressAnimationController, curve: Curves.easeIn))
      ..addListener(() {
        setState(() {
          progressDegrees = widget.goalCompleted * _progressAnimation.value;
        });
      });
    _radialProgressAnimationController.forward();
  }

  @override
  void dispose() {
    _radialProgressAnimationController.dispose();
    super.dispose();
  }

  bool _buttonPressed = false;
  bool _loopActive = false;
  double x = 0;

  void _increaseCounterWhilePressed() async {
    if (_loopActive) return; // check if loop is active

    _loopActive = true;

    while (_buttonPressed) {
      // do your thing
      setState(() {
        progressDegrees = widget.goalCompleted + x * _progressAnimation.value;
      });
      x += 0.01;

      // wait a second
      await Future.delayed(Duration(milliseconds: 50));
    }

    _loopActive = false;
  } // recording

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (details) {
        _buttonPressed = true;
        _increaseCounterWhilePressed();
      }, // recording
      onPointerUp: (details) {
        _buttonPressed = false;
        setState(() {
          progressDegrees = widget.goalCompleted + 0 * _progressAnimation.value;
        });
        x = 0;
      }, // stop recording
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.all(Radius.circular(45))),
        child: CustomPaint(
          child: Container(
            height: 200.0,
            width: 200.0,
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Container(),
          ),
          painter: RadialPainter(progressDegrees),
        ),
      ),
    );
  }
}

class RadialPainter extends CustomPainter {
  double progressInDegrees;

  RadialPainter(this.progressInDegrees);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    Offset center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width / 2, paint);

    Paint progressPaint = Paint()
      ..shader = LinearGradient(
              colors: [Colors.red, Colors.purple, Colors.purpleAccent])
          .createShader(Rect.fromCircle(center: center, radius: size.width / 2))
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    canvas.drawArc(
        Rect.fromCircle(center: center, radius: size.width / 2),
        math.radians(-90),
        math.radians(progressInDegrees),
        false,
        progressPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
