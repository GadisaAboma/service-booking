import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSlideTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(
          animation.status == AnimationStatus.forward ? -1.0 : 1.0,
          0.0,
        ),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: animation, curve: curve ?? Curves.easeInOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: Offset(
            secondaryAnimation.status == AnimationStatus.completed ? -1.0 : 1.0,
            0.0,
          ),
        ).animate(
          CurvedAnimation(
            parent: secondaryAnimation,
            curve: curve ?? Curves.easeInOut,
          ),
        ),
        child: child,
      ),
    );
  }
}
