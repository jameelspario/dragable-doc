import 'package:flutter/material.dart';

import 'custom_tooltip/custom_tooltip.dart';
import 'reorderble_wrap/reorderable_wrap.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock(
            items: const [
              {"icon": Icons.person, "name": "Person"},
              {"icon": Icons.message, "name": "Message"},
              {"icon": Icons.call, "name": "Call"},
              {"icon": Icons.camera, "name": "Camera"},
              {"icon": Icons.photo, "name": "Photo"},
            ],
            builder: (e, show) {
              return CustomTooltip(
                key: ValueKey(e),
                text: show ? null : "${e['name']}",
                textStyle: const TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.w500),
                child: Container(
                  constraints: const BoxConstraints(minWidth: 48),
                  height: 48,
                  width: 48,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:
                        Colors.primaries[e.hashCode % Colors.primaries.length],
                  ),
                  child: Center(
                      child: Icon(e['icon'] as IconData?, color: Colors.white)),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Dock of the reorderable [items].
class Dock<T> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  /// Initial [T] items to put in this [Dock].
  final List<T> items;

  /// Builder building the provided [T] item.
  final Widget Function(T, bool showTooltip) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

/// State of the [Dock] used to manipulate the [_items].
class _DockState<T> extends State<Dock<T>> {
  /// [T] items being manipulated.
  late final List<T> _items = widget.items.toList();
  bool anim = false;
  int hoveredIndex = -1;
  int? draggedIndex;
  int? placeholderIndex;
  int? draggingIndex;
  double? dragPositionX;
  double? dragPositionY;
  double? initialDragPositionX;
  double? initialDragPositionY;
  bool isDragging = false;

  // Function to compute y-offsets
  List<double> computeOffsets(int hoverIndex, int length) {
    List<double> offsets = List.filled(length, 0.0); // Default all to 0

    if (hoverIndex == -1) return offsets; // No hover, return default offsets

    for (int i = 0; i < length; i++) {
      if (i < hoverIndex) {
        // Items on the left of the hovered index
        offsets[i] = -10.0 * (i + 1) / (hoverIndex + 1);
      } else if (i > hoverIndex) {
        // Items on the right of the hovered index
        offsets[i] = -10.0 * (length - i) / (length - hoverIndex);
      } else {
        // Hovered index
        offsets[i] = -10.0;
      }
    }
    return offsets;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => anim = true),
      onExit: (_) {
        if(!isDragging) {
          setState(() {
            hoveredIndex = -1;
            anim = false;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.black12,
        ),
        padding: const EdgeInsets.all(4),
        transform: Matrix4.identity()..scale(anim ? 1.1 : 1.0),
        child: ReorderableWrap(
            scrollDirection: Axis.horizontal,
            needsLongPressDraggable: false,
            children: _items.asMap().entries.map((entry) {
              final int index = entry.key;
              final dynamic item = entry.value;
              return MouseRegion(
                onEnter: (_) => setState(() => hoveredIndex = index),
                // onExit: (_) => setState(() => hoveredIndex = -1),
                child: hoveredIndex == -1
                    ? widget.builder(item, isDragging)
                    : AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        transform: Matrix4.identity()
                          ..translate(
                              0.0,
                              computeOffsets(
                                  hoveredIndex, _items.length)[index]),
                        child: widget.builder(item, isDragging),
                      ),
              );
            }).toList(),
            buildDraggableFeedback: (context, constraint, child) => Material(
                  color: Colors.transparent,
                  child: child,
                ),
            onDragUpdate: (detail) {},
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                final row = _items.removeAt(oldIndex);
                _items.insert(newIndex, row);
                isDragging = false;
                hoveredIndex = -1;
                anim = false;
              });
            },
            onNoReorder: (int index) {
              //this callback is optional
              setState(() {
                isDragging = false;
                hoveredIndex = -1;
                anim = false;
              });

              debugPrint(
                  '${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
            },
            onReorderStarted: (int index) {
              //this callback is optional
              setState(() {
                isDragging = true;
                hoveredIndex = index;
              });
              debugPrint(
                  '${DateTime.now().toString().substring(5, 22)} reorder started: index:$index');
            }),
      ),
    );
  }
}
