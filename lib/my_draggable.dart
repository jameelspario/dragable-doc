import 'package:flutter/material.dart';

class MyDraggable extends StatefulWidget {
  const MyDraggable(
      {required this.child, this.index = -1, required this.globalKey, Key? key})
      : super(key: key);
  final Widget child;
  final int index;
  final GlobalKey globalKey;

  @override
  _MyDraggableState createState() => _MyDraggableState();
}

class _MyDraggableState extends State<MyDraggable> {
  double? dragPositionX;
  double? dragPositionY;
  double? initialDragPositionX;
  double? initialDragPositionY;

  bool _checkDragPosition() {
    RenderBox renderBox =
        widget.globalKey.currentContext!.findRenderObject() as RenderBox;
    Offset listViewPosition = renderBox.localToGlobal(Offset.zero);
    double listViewTop = listViewPosition.dy;
    double listViewBottom = listViewTop + renderBox.size.height;

    // Compare the drag Y position with ListView's bounds
    if (dragPositionY != null) {
      if (dragPositionY! < listViewTop) {
        print('Drag is above the ListView');
        return false;
      } else if (dragPositionY! > listViewBottom) {
        print('Drag is below the ListView');
        return false;
      } else {
        print('Drag is inside the ListView');
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<int>(builder: (context, candidateData, rejectedData) {
      return Draggable<int>(
          data: widget.index,
          feedback: Material(
            color: Colors.transparent,
            child: widget.child,
          ),
          // childWhenDragging: _checkDragPosition()
          //     ? AnimatedContainer(
          //         duration: Duration(milliseconds: 300),
          //         width: 60,
          //         height: 60,
          //         color: Colors.transparent,
          //       )
          //     : Container(),
          childWhenDragging: Container(),
          onDragUpdate: (details) {
            initialDragPositionX ??= details.globalPosition.dx;
            initialDragPositionY ??= details.globalPosition.dy;
            setState(() {
              dragPositionX =
                  details.globalPosition.dx; // Track horizontal position
              dragPositionY =
                  details.globalPosition.dy; // Track horizontal position
            });
          },
          child: widget.child);
    });
  }
}
