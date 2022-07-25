import 'package:flutter/material.dart';

class SingleSelection<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) title;
  final bool Function(T? currentItem, T newItem) compare;
  final T? initialValue;
  final Function(T? item)? onChanged;
  final Function(T item, bool selected)? itemBuilder;
  final EdgeInsets? padding;
  final EdgeInsets? paddingItem;
  final bool isRow;
  final bool wrap;
  final bool disable;
  final bool isGridview;
  final int itemPerRow;
  final double spacingHorizontal;
  final double spacingVertical;
  final double childAspectRatio;

  const SingleSelection({
    Key? key,
    required this.items,
    required this.title,
    required this.compare,
    this.initialValue,
    this.onChanged,
    this.itemBuilder,
    this.padding,
    this.paddingItem,
    this.disable = false,
    this.isRow = false,
    this.wrap = false,
    this.isGridview = false,
    this.spacingHorizontal = 4,
    this.spacingVertical = 4,
    this.itemPerRow = 2,
    this.childAspectRatio = 4,
  }) : super(key: key);

  @override
  State<SingleSelection<T>> createState() => _SingleSelectionState();
}

class _SingleSelectionState<T> extends State<SingleSelection<T>> {
  T? _selectedItem;
  late ThemeData _theme;
  TextStyle? _textTheme;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _selectedItem = widget.initialValue;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = Theme.of(context);
    _textTheme ??= _theme.textTheme.bodyText1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (widget.isRow) {
      if (widget.wrap) {
        return Wrap(
          spacing: widget.spacingHorizontal,
          runSpacing: widget.spacingVertical,
          children: _buildItems(),
        );
      }
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _buildItems(),
        ),
      );
    } else {
      if (!widget.isGridview) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildItems(),
        );
      }
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.itemPerRow,
          childAspectRatio: widget.childAspectRatio,
          mainAxisSpacing: widget.spacingHorizontal,
          crossAxisSpacing: widget.spacingVertical,
        ),
        itemBuilder: (context, index) {
          final item = widget.items[index];
          return _buildItem(item);
        },
      );
    }

  }

  List<Widget> _buildItems() {
    return List.generate(
        widget.items.length,
            (index) => Wrap(
          children: [
            _buildItem(widget.items[index]),
            if (index < widget.items.length - 1)
              SizedBox(
                width: widget.spacingHorizontal,
              ),
          ],
        ));
  }

  Widget _buildItem(T item) {
    final selected = widget.compare.call(_selectedItem, item);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!widget.disable) {
          if (selected) {
            _selectedItem = null;
          } else {
            _selectedItem = item;
          }
          setState(() {});
          widget.onChanged?.call(_selectedItem);
        }
      },
      child: Container(
        padding: widget.paddingItem ?? const EdgeInsets.all(4),
        child: widget.itemBuilder?.call(item, selected) ??
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                selected
                    ? Icon(
                  Icons.radio_button_checked_outlined,
                  color: widget.disable ? _theme.disabledColor : _theme.primaryColor,
                )
                    : Icon(
                  Icons.radio_button_off_outlined,
                  color: _theme.disabledColor,
                ),
                const SizedBox(width: 4,),
                !widget.isRow || widget.wrap
                    ? Flexible(
                  child: Text(
                    widget.title.call(item),
                    style: widget.disable ? _textTheme?.apply(color: Colors.black45) : _textTheme,
                  ),
                )
                    : Text(
                  widget.title.call(item),
                  style: widget.disable ? _textTheme?.apply(color: Colors.black45) : _textTheme,
                ),
              ],
            ),
      ),
    );
  }
}
