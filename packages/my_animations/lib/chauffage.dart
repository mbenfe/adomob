part of my_animations;

class IconHeaterAnimated extends StatefulWidget {
  const IconHeaterAnimated({Key? key, required this.etat}) : super(key: key);
  final bool etat;
  @override
  IconHeaterAnimatedState createState() => IconHeaterAnimatedState();
}

class IconHeaterAnimatedState extends State<IconHeaterAnimated> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: width / 2.7,
      width: width / 2.7,
      child: widget.etat == true
          ? Animator<double>(
              duration: const Duration(milliseconds: 1000),
              cycles: 0,
              curve: Curves.easeInOut,
              tween: Tween<double>(begin: 5.0, end: 8.0),
              resetAnimationOnRebuild: true,
              builder: (context, animatorState, child) => Icon(
                MdiIcons.radiator,
                size: animatorState.value * 5,
                color: Colors.red,
              ),
            )
          : Animator<double>(
              duration: const Duration(milliseconds: 1000),
              cycles: 0,
              curve: Curves.easeInOut,
              tween: Tween<double>(begin: 8.0, end: 8.0),
              resetAnimationOnRebuild: true,
              // builder: (context, animatorState, child) => Icon(
              //   Icons.audiotrack,
              //   size: animatorState.value * 5,
              //   color: Colors.grey,
              // ),
              builder: (context, animatorState, child) => Icon(
                MdiIcons.radiatorOff,
                size: animatorState.value * 5,
                color: Colors.grey,
              ),
            ),
    );
  }
}
