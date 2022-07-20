import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StepVerticalView<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(T) icon;
  final Widget Function(T)? title;
  final Color? activeColor;
  final Color? inActiveColor;
  final Color? inProgressColor;
  final Color? errorColor;
  final double? lineHeight;
  final double? lineWidth;
  final int currentStep;
  final bool isRow;

  const StepVerticalView({
    Key? key,
    required this.items,
    required this.icon,
    this.title,
    this.activeColor,
    this.inActiveColor,
    this.inProgressColor,
    this.errorColor,
    this.lineWidth = 50,
    this.lineHeight = 2.0,
    this.currentStep = 0,
    this.isRow = false,
  }) : super(key: key);

  @override
  Widget build (BuildContext context) => SizedBox(
    width: double.maxFinite,
    child: isRow ? SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _iconViews(),
          ),
        ],
      ),
    ) : Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _iconViews(),
        ),
      ],
    ),
  );

  List<Widget> _iconViews() {
    var list = <Widget>[];
    items.asMap().forEach((i, item) {

      var lineColor = currentStep > i
          ? activeColor
          : inActiveColor;

      var iconColor = (i == 0 || currentStep >= i)
          ? currentStep == i ? inProgressColor : activeColor
          : inActiveColor;
      list.add(Column(
        children: [
          icon.call(item),
          if (title != null) title?.call(item) ?? const SizedBox(),
        ],
      ));

      //line between icons
      if (i != items.length - 1) {
        if (isRow == true) {
          list.add(Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            width: lineWidth,
            height: lineHeight,
            color: lineColor,
          ));
        } else {
          list.add(Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              height: lineHeight,
              color: lineColor,
            ),
          ));
        }
      }
    });

    return list;
  }

  List<Widget> _titleViews() {
    var list = <Widget>[];
    for (var item in items) {
      list.add(title?.call(item) ?? const SizedBox());
    }
    return list;
  }
}
