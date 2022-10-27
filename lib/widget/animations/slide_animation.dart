import 'package:flutter/material.dart';

class SlideAnimation extends StatefulWidget {
  const SlideAnimation({
    Key? key,
    required this.child,
    required this.startOffset,
    required this.endOffset,
    this.duration,
    this.animationCurve,
    this.onEnd,
    this.animationController,
    this.toAutoAnimate = false,
  }) : super(key: key);

  final Widget child;
  final Offset startOffset;
  final Offset endOffset;

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
  State<SlideAnimation> createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<SlideAnimation>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> animation;
  late AnimationController animationController;

  @override
  void initState() {
    animationController = widget.animationController ??
        AnimationController(
            duration: widget.duration ?? const Duration(milliseconds: 500),
            vsync: this);
    final Animation<double> curve = CurvedAnimation(
        parent: animationController,
        curve: widget.animationCurve ?? Curves.easeOut);
    Tween<Offset> tween =
        Tween(begin: widget.startOffset, end: widget.endOffset);
    animation = tween.animate(curve);
    animation.addListener(() {
      setState(() {});
    });
    if (widget.toAutoAnimate) {
      animationController
          .forward()
          .then((value) => widget.onEnd != null ? widget.onEnd!() : null);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation,
      child: widget.child,
    );
  }
}
