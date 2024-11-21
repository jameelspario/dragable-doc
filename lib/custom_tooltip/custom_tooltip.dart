import 'package:flutter/material.dart';

import 'drawable_chat.dart';

String extractIconName(IconData iconData) {
  final String description = iconData.toString();
  final RegExp regex = RegExp(r'(?<=Icons\.)\w+');
  final Match? match = regex.firstMatch(description);
  return match?.group(0) ?? 'Unknown';
}

// custom tool tips show on hover item
class CustomTooltip extends StatelessWidget {
  const CustomTooltip({this.text, this.textStyle, this.child, super.key});

  final String? text;
  final Widget? child;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return text == null
        ? Container(
            child: child,
          )
        : Tooltip(
            preferBelow: false,
            verticalOffset: 40,
            decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            richMessage: WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: CustomTooltipsBackground(
                  color: Colors.black12,
                  text: text!,
                  textStyle: textStyle,
                )),
            child: child,
          );
  }
}
