import 'package:flutter/material.dart';

class StepHorizontalView<T> extends StatelessWidget {
  final List<T> items;
  final int currentStep;
  final double lineHeight;
  final Color? activeColor;
  final Color? inActiveColor;
  final Color? inProgressColor;
  final Color? errorColor;
  final double? lineWidth;
  final Widget Function(T)? titleBuilder;
  final Widget Function(T)? icon;
  final bool isErrorLine;
  final bool isCenterIcon;
  final double iconSize;

  const StepHorizontalView({
    Key? key,
    required this.items,
    this.currentStep = 0,
    this.lineWidth = 2.0,
    this.lineHeight = 50,
    this.activeColor,
    this.inActiveColor,
    this.inProgressColor,
    this.errorColor,
    this.titleBuilder,
    this.icon,
    this.isErrorLine = false,
    this.isCenterIcon = true,
    this.iconSize = 24,
  }) : assert(currentStep <= items.length - 1),
        assert(currentStep >= 0),
        super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.maxFinite,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _iconViews(context),
    ),
  );

  List<Widget> _iconViews(BuildContext context) {
    final theme = Theme.of(context);
    final _lineHeight = lineHeight/2;
    var list = <Widget>[];
    items.asMap().forEach((index, item) {
      Color iconColor = index == 0 || index <= currentStep ? activeColor ?? theme.primaryColor : inActiveColor ?? theme.disabledColor;
      Color lineColor = index <= currentStep ? iconColor : inActiveColor ?? theme.disabledColor;
      Color lineColor2 = currentStep > index ? iconColor : inActiveColor ?? theme.disabledColor;

      if ((currentStep == index) && errorColor != null && isErrorLine) {
        lineColor = errorColor ?? Colors.red;
      }
      if ((currentStep == index + 1) && errorColor != null && isErrorLine) {
        lineColor2 = errorColor ?? Colors.red;
      }

      if (index != 0 && index < items.length) {
        list.add(
          Row(
            children: [
              SizedBox(
                width: iconSize,
                child: Center(
                  child: Container(
                    height: _lineHeight,
                    width: lineWidth,
                    color: lineColor,
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        );
      }
      list.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (isCenterIcon) Expanded(
                    child: Container(
                      width: lineWidth,
                      decoration: BoxDecoration(color: index == 0 ? Colors.transparent : lineColor),
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
                  if (index < items.length - 1) Expanded(
                    child: Container(
                      width: 2,
                      decoration: BoxDecoration(color: lineColor2),
                    ),
                  ),
                ],
              ),
              if (titleBuilder != null) ...[
                const SizedBox(width: 8),
                Flexible(child: Container(
                  padding: const EdgeInsets.only(top: 6),
                  child: titleBuilder?.call(item) ?? const SizedBox(),
                ))
              ],
            ],
          ),
        ),
      );

      if (index < items.length - 1) {
        list.add(
          Row(
            children: [
              SizedBox(
                width: iconSize,
                child: Center(
                  child: Container(
                    height: _lineHeight,
                    width: lineWidth,
                    color: lineColor2,
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        );
      }
    });
    return list;
  }

}