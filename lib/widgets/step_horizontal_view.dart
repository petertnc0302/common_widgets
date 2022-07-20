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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.maxFinite,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _iconViews(),
    ),
  );

  List<Widget> _iconViews() {
    final _lineHeight = lineHeight/2;
    var list = <Widget>[];
    items.asMap().forEach((index, item) {
      final iconColor = currentStep == 0 || index <= currentStep ? activeColor : inActiveColor;
      final lineColor = index <= currentStep ? iconColor : inActiveColor;
      final lineColor2 = currentStep > index? iconColor : inActiveColor;
      if (index != 0 && index < items.length) {
        list.add(
          Row(
            children: [
              SizedBox(
                width: 24,
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

      /*
      * Expanded(
                      child: Container(
                        width: lineWidth,
                        color: lineColor,
                      ),
                    ),
                    *
                    * Icon(
                      Icons.map,
                      color: errorColor != null && currentStep == index ? errorColor : iconColor,
                      size: 24,
                    ),
                    *
                    *               Expanded(child: titleBuilder?.call(item) ?? const SizedBox())

      * */

      list.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Expanded(
                    child: Container(
                      width: 2,
                      decoration: BoxDecoration(color: index == 0 ? Colors.transparent : lineColor2),
                    ),
                  ),
                  Icon(
                    Icons.map,
                    color: errorColor != null && currentStep == index ? errorColor : iconColor,
                    size: 24,
                  ),
                  if (index < items.length - 1) Expanded(
                    child: Container(
                      width: 2,
                      decoration: BoxDecoration(color: lineColor2),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Flexible(child: titleBuilder?.call(item) ?? const SizedBox())
            ],
          ),
        ),
      );

      if (index < items.length - 1) {
        list.add(
          Row(
            children: [
              SizedBox(
                width: 24,
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