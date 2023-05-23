part of my_animations;

//* severity 1    vert doucement     500
//* severity 2    vert rapide       1500
//* severity 3    orange doucement  3000
//* severity 4    orange rapide     4000
//* severity 5    rouge doucement   5000
//* severity 6    rouge rapide      1200

class AnimationRipplePower extends StatefulWidget {
  const AnimationRipplePower(this.power, {super.key});
  final double power;
  @override
  AnimationRipplePowerState createState() => AnimationRipplePowerState();
}

class AnimationRipplePowerState extends State<AnimationRipplePower> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    if (widget.power < 500) {}
    if (widget.power < 1500) {}
    if (widget.power < 3000) {}
    if (widget.power < 4000) {}
    if (widget.power < 5000) {}
    if (widget.power < 1200) {}

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        } else if (status == AnimationStatus.completed) {
          _animationController.repeat();
        }
      });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomPaint(
          painter: MyCustomPainter(_animation.value, Colors.red),
          child: SizedBox(height: 100, width: 100, child: Container()),
        ),
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  final double animationValue;
  final Color couleur;
  MyCustomPainter(this.animationValue, this.couleur);

  @override
  void paint(Canvas canvas, Size size) {
    for (int value = 3; value >= 0; value--) {
      circle(canvas, Rect.fromLTRB(0, 0, size.width, size.height), value + animationValue);
    }
  }

  void circle(Canvas canvas, Rect rect, double value) {
    Paint paint = Paint()
//      ..color = Color(0xff19DC7C).withOpacity((1 - (value / 4)).clamp(.0, 1));
      ..color = couleur.withOpacity((1 - (value / 4)).clamp(.0, 1));

    canvas.drawCircle(rect.center, sqrt((rect.width * .5 * rect.width * .5) * value / 2), paint);
  }

  @override
  bool shouldRepaint(MyCustomPainter oldDelegate) {
    return true;
  }
}
