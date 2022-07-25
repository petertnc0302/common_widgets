import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StepVerticalView<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(T)? icon;
  final Widget Function(T)? title;
  final Color? activeColor;
  final Color? inActiveColor;
  final Color? inProgressColor;
  final Color? errorColor;
  final double? lineHeight;
  final double? lineWidth;
  final double _itemWidth;
  final int currentStep;
  final bool isRow;
  final bool isErrorLine;
  final bool isCenterIcon;
  final double iconSize;

  const StepVerticalView({
    Key? key,
    required this.items,
    this.icon,
    this.title,
    this.activeColor,
    this.inActiveColor,
    this.inProgressColor,
    this.errorColor,
    this.lineWidth = 20,
    this.lineHeight = 2.0,
    this.currentStep = 0,
    this.isRow = false,
    this.isErrorLine = false,
    this.isCenterIcon = true,
    this.iconSize = 24,
    double itemWidth = 150,
  }) :
        _itemWidth = itemWidth + iconSize,
        assert(currentStep <= items.length - 1),
        assert(currentStep >= 0),
        super(key: key);

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
            children: _iconViews(context),
          ),
        ],
      ),
    ) : Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _iconViews(context),
        ),
      ],
    ),
  );

  List<Widget> _iconViews(BuildContext context) {
    var list = <Widget>[];
    items.asMap().forEach((index, item) {

      var lineColor = currentStep > index
          ? activeColor ?? Theme.of(context).primaryColor
          : inActiveColor ?? Theme.of(context).disabledColor;

      var lineColor2 = currentStep >= index
          ? activeColor ?? Theme.of(context).primaryColor
          : inActiveColor ?? Theme.of(context).disabledColor;

      var iconColor = (index == 0 || currentStep >= index)
          ? currentStep == index
              ? inProgressColor ?? Theme.of(context).primaryColor
              : activeColor ?? Theme.of(context).primaryColor
          : inActiveColor ?? Theme.of(context).disabledColor;

      if ((currentStep == index + 1) && errorColor != null && isErrorLine) {
        lineColor = errorColor ?? Colors.red;
      }
      if ((currentStep == index) && errorColor != null && isErrorLine) {
        lineColor2 = errorColor ?? Colors.red;
      }
      list.add(Container(
        width: isRow && index != items.length - 1
            ?  _itemWidth
            : null,
        constraints: BoxConstraints(
          maxWidth: _itemWidth
        ),
        child: Column(
          crossAxisAlignment: isCenterIcon ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isRow && isCenterIcon) Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: iconSize/2),
                    height: lineHeight,
                    color: index == 0 ? null : lineColor2,
                  ),
                ),
                Container(
                  width: iconSize,
                  height: iconSize,
                  alignment: Alignment.center,
                  child: icon?.call(item) ??
                      Icon(
                        Icons.circle,
                        color: errorColor != null && currentStep == index ? errorColor : iconColor,
                        size: iconSize,
                      ),
                ),
                if (isRow && (index != items.length - 1 || isCenterIcon)) Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: iconSize/2),
                    height: lineHeight,
                    color: index < items.length - 1 ? lineColor : null,
                  ),
                ),
              ],
            ),
            if (title != null && isRow) Padding(
              padding: const EdgeInsets.only(left: 8),
              child: title?.call(item) ?? const SizedBox(),
            ),
          ],
        ),
      ));

      //line between icons
      if (index != items.length - 1) {
        if (isRow == true) {
          list.add(Container(
            margin: EdgeInsets.symmetric(vertical: iconSize/2),
            width: lineWidth,
            height: lineHeight,
            color: lineColor,
          ));
        } else {
          list.add(Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: iconSize/2),
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
