import 'package:flutter/material.dart';

class DraggableMenu extends StatefulWidget {
  @override
  _DraggableMenuState createState() => _DraggableMenuState();
}

class _DraggableMenuState extends State<DraggableMenu> {
  List<String> _items = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];
  int? draggingIndex; // Track the dragged index for placeholder

  double? dragPositionX;
  double? dragPositionY;
  double? initialDragPositionX;
  double? initialDragPositionY;
  late GlobalKey _listViewKey = GlobalKey(); // GlobalKey for the ListView

  bool _checkDragPosition() {
    RenderBox renderBox =
        _listViewKey.currentContext!.findRenderObject() as RenderBox;
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Draggable Menu with Animation"),
      ),
      body: Center(
        child: Container(
          height: 80,
          child: ListView.builder(
            key: _listViewKey,
            scrollDirection: Axis.horizontal,
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return DragTarget<int>(
                onWillAccept: (draggedIndex) {
                  setState(() {
                    draggingIndex = index;
                  });
                  return true;
                },
                onAccept: (draggedIndex) {
                  setState(() {
                    final draggedItem = _items.removeAt(draggedIndex);
                    _items.insert(index, draggedItem);
                    draggingIndex = null;
                    dragPositionX = null;
                    dragPositionY = null;
                  });
                },
                onLeave: (_) {
                  setState(() {
                    draggingIndex = null;
                    dragPositionX = null;
                    dragPositionY = null;
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  return Draggable<int>(
                    data: index,
                    feedback: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: 60,
                        height: 60,
                        alignment: Alignment.center,
                        color: Colors.blueAccent,
                        child: Text(
                          _items[index],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    childWhenDragging: _checkDragPosition()
                        ? AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            width: 60,
                            height: 60,
                            color: Colors.transparent,
                          )
                        : Container(),
                    onDragStarted: () {},
                    onDragUpdate: (details) {
                      initialDragPositionX ??= details.globalPosition.dx;
                      initialDragPositionY ??= details.globalPosition.dy;
                      setState(() {
                        dragPositionX = details
                            .globalPosition.dx; // Track horizontal position
                        dragPositionY = details
                            .globalPosition.dy; // Track horizontal position
                      });
                    },
                    onDragEnd: (detail) {},
                    onDragCompleted: () {},
                    child: Stack(
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          width: 60,
                          height: 60,
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: draggingIndex == index
                                ? Colors.blueGrey
                                : Colors.blueAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _items[index],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        if (draggingIndex == index && dragPositionX != null)
                          Positioned(
                            left: dragPositionX! - 30,
                            // Adjust for center alignment
                            top: 0,
                            child: Container(
                              width: 60,
                              height: 60,
                              color: Colors.blueAccent.withOpacity(0.7),
                              alignment: Alignment.center,
                              child: Text(
                                _items[index],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
