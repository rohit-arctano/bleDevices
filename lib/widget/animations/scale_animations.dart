import 'package:flutter/material.dart';

class ScaleAnimation extends StatefulWidget {
  const ScaleAnimation({
    Key? key,
    required this.child,
    required this.startScale,
    required this.endScale,
    this.duration,
    this.animationCurve,
    this.onEnd,
    this.animationController,
    this.toAutoAnimate = false,
  }) : super(key: key);

  final Widget child;
  final double startScale;
  final double endScale;

  /// Default values is 500ms
  ///
  /// Used when animationController is null
  final Duration? duration;

  /// Default value is Curves.easeOut
  final Curve? animationCurve;

  final Function()? onEnd;
  final AnimationController? animationController;

  final bool toAutoAnimate;

  @override
  State<ScaleAnimation> createState() => _ScaleAnimationState();
}

class _ScaleAnimationState extends State<ScaleAnimation> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    animationController = widget.animationController ?? AnimationController(duration: widget.duration ?? const Duration(milliseconds: 500), vsync: this);
    final Animation<double> curve = CurvedAnimation(parent: animationController, curve: widget.animationCurve ?? Curves.easeOut);
    Tween<double> tween = Tween(begin: widget.startScale, end: widget.endScale);
    animation = tween.animate(curve);
    animation.addListener(() {
      setState(() {});
    });
    if(widget.toAutoAnimate) {
      animationController.forward().then((value) => widget.onEnd != null ? widget.onEnd!() : null);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: widget.child,
    );
  }
}
