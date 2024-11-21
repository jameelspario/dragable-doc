import 'package:flutter/material.dart';

class AnimatedContainer1 extends StatefulWidget {
  const AnimatedContainer1({this.child, this.width, this.height,  super.key});
  final Widget? child;
  final double? width;
  final double? height;

  @override
  State<AnimatedContainer1> createState() => _AnimatedContainerState();
}

class _AnimatedContainerState extends State<AnimatedContainer1> {
  bool anim = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => anim= true),
      onExit: (_) => setState(() => anim = false),
      child: AnimatedContainer(
        height: widget.height,
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black12,
        ),
        transform: Matrix4.identity()
          ..scale(anim ? 1.1 : 1.0),
        child: widget.child,
      ),
    );
  }
}
