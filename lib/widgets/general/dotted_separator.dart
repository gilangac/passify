// ignore_for_file: prefer_const_declarations, camel_case_types, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class dotSeparator extends StatelessWidget {
  final double height;
  final Color color;

  const dotSeparator({this.height = 0.6, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 4.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Flex(
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              );
            }),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
          ),
        );
      },
    );
  }
}
