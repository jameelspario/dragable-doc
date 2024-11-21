import 'package:flutter/material.dart';

class AnimatedItem extends StatefulWidget {
  const AnimatedItem({this.child, Key? key}) : super(key: key);
  final Widget? child;

  @override
  _AnimatedItemState createState() => _AnimatedItemState();
}

class _AnimatedItemState extends State<AnimatedItem> {
  bool anim = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => anim= true),
      onExit: (_) => setState(() => anim = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..scale(anim ? 1.1 : 1.0),
        child: widget.child,
      ),
    );
  }
}
