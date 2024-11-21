import 'package:flutter/material.dart';
class DraggableHorizontalList extends StatefulWidget {
  final List items;

  const DraggableHorizontalList({
    super.key,
    required this.items
  });

  @override
  _DraggableHorizontalListState createState() => _DraggableHorizontalListState();
}

class _DraggableHorizontalListState extends State<DraggableHorizontalList> {
  late List<IconData> _items;
  IconData? _draggedItem;
  Offset? _localPosition;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
  }

  Widget _buildDraggableItem(IconData icon, int index) {
    return Draggable<IconData>(
      key: ValueKey(icon),
      data: icon,
      feedback: _buildFeedbackWidget(icon),
      childWhenDragging: Container(
        width: 60,
        height: 60,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onDragStarted: () {
        setState(() {
          _draggedItem = icon;
        });
      },
      onDragEnd: (details) {
        setState(() {
          _draggedItem = null;
          _localPosition = null;
        });
      },
      onDraggableCanceled: (velocity, offset) {
        // Handle cancellation
        setState(() {
          _draggedItem = null;
          _localPosition = null;
        });
      },
      child: DragTarget<IconData>(
        builder: (context, candidateData, rejectedData) {
          return Container(
            width: 60,
            height: 60,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.primaries[icon.hashCode % Colors.primaries.length],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(icon, color: Colors.white),
            ),
          );
        },
        onAccept: (data) {
          _handleItemReorder(data);
        },
        onMove: (details) {
          setState(() {
            _localPosition = details.offset;
          });
        },
      ),
    );
  }

  Widget _buildFeedbackWidget(IconData icon) {
    return Transform.scale(
      scale: 1.2,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.primaries[icon.hashCode % Colors.primaries.length],
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }

  void _handleItemReorder(IconData draggedItem) {
    setState(() {
      // Remove the dragged item
      _items.remove(draggedItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<IconData>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: _items.map((icon) => _buildDraggableItem(icon, _items.indexOf(icon))).toList(),
            ),
          ),
        );
      },
      onAccept: (data) {
        // Handle dropping outside the original list
        if (_localPosition != null) {
          RenderBox? renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            Offset localOffset = renderBox.globalToLocal(_localPosition!);

            // Check if dragged vertically out of bounds (remove item)
            if (localOffset.dy < -50 || localOffset.dy > renderBox.size.height + 50) {
              setState(() {
                _items.remove(data);
              });
            }
          }
        }
      },
      onMove: (details) {
        setState(() {
          _localPosition = details.offset;
        });
      },
    );
  }
}