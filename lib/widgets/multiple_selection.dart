import 'package:flutter/material.dart';

class MultipleSelection<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) title;
  final bool Function(T? currentItem, T newItem) compare;
  final List<T>? initialValues;
  final Function(List<T>? item)? onChanged;
  final Widget Function(T item, bool selected)? itemBuilder;
  final String titleSelectAll;
  final Widget Function(bool)? itemBuilderSelectAll;
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
  final bool selectAll;

  const MultipleSelection({
    Key? key,
    required this.items,
    required this.title,
    required this.compare,
    this.initialValues,
    this.onChanged,
    this.itemBuilder,
    this.titleSelectAll = 'All',
    this.itemBuilderSelectAll,
    this.padding,
    this.paddingItem,
    this.disable = false,
    this.isRow = false,
    this.wrap = false,
    this.isGridview = false,
    this.selectAll = false,
    this.spacingHorizontal = 4,
    this.spacingVertical = 4,
    this.itemPerRow = 2,
    this.childAspectRatio = 4,
  }) : super(key: key);

  @override
  State<MultipleSelection<T>> createState() => _MultipleSelectionState<T>();
}

class _MultipleSelectionState<T> extends State<MultipleSelection<T>> {
  List<T>? _selectedItem = <T>[];
  bool _isSelectedAll = false;
  late ThemeData _theme;
  TextStyle? _textTheme;

  @override
  void initState() {
    super.initState();
    if (widget.initialValues != null) {
      _selectedItem = widget.initialValues;
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
        itemCount: widget.selectAll ? widget.items.length + 1 : widget.items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.itemPerRow,
          childAspectRatio: widget.childAspectRatio,
          mainAxisSpacing: widget.spacingHorizontal,
          crossAxisSpacing: widget.spacingVertical,
        ),
        itemBuilder: (context, index) {
          if (widget.selectAll) {
            int i = index - 1;
            if (i < 0) {
              return _itemAll();
            }
            final item = widget.items[i];
            return _buildItem(item);
          }
          final item = widget.items[index];
          return _buildItem(item);
        },
      );
    }

  }

  List<Widget> _buildItems() {
    List<Widget> widgetItems = <Widget>[];

    if (widget.selectAll) {
      widgetItems.add(_itemAll());
    }

    widgetItems.addAll(List.generate(
        widget.items.length,
            (index) => Wrap(
          children: [
            _buildItem(widget.items[index]),
            if (index < widget.items.length - 1)
              SizedBox(
                width: widget.spacingHorizontal,
              ),
          ],
        )).toList());

    return widgetItems;
  }

  Widget _buildItem(T item) {
    final selected = _selectedItem?.any((currentItem) => widget.compare.call(currentItem, item)) ?? false;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!widget.disable) {
          if (selected) {
            _selectedItem?.removeWhere((currentItem) => widget.compare.call(currentItem, item));
            _isSelectedAll = false;
          } else {
            _selectedItem?.add(item);
            if (_selectedItem?.length == widget.items.length) {
              _isSelectedAll = true;
            }
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
                  Icons.check_box_rounded,
                  color: widget.disable ? _theme.disabledColor : _theme.primaryColor,
                )
                    : Icon(
                  Icons.check_box_outline_blank,
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

  Widget _itemAll() {
    return Wrap(
      runAlignment: WrapAlignment.center,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (!widget.disable) {
              if (_isSelectedAll) {
                _selectedItem = [];
                _isSelectedAll = false;
              } else {
                _selectedItem = [...widget.items];
                _isSelectedAll = true;
              }
              setState(() {});
              widget.onChanged?.call(_selectedItem);
            }
          },
          child: Container(
            padding: widget.paddingItem ?? const EdgeInsets.all(4),
            child: widget.itemBuilderSelectAll?.call(_isSelectedAll) ??
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _isSelectedAll
                        ? Icon(
                      Icons.check_box_rounded,
                      color: widget.disable ? _theme.disabledColor : _theme.primaryColor,
                    )
                        : Icon(
                      Icons.check_box_outline_blank,
                      color: _theme.disabledColor,
                    ),
                    const SizedBox(width: 4,),
                    !widget.isRow || widget.wrap
                        ? Flexible(
                      child: Text(
                        widget.titleSelectAll,
                        style: widget.disable ? _textTheme?.apply(color: Colors.black45) : _textTheme,
                      ),
                    )
                        : Text(
                      widget.titleSelectAll,
                      style: widget.disable ? _textTheme?.apply(color: Colors.black45) : _textTheme,
                    ),
                  ],
                ),
          ),
        ),
        SizedBox(
          width: widget.spacingHorizontal,
        ),
      ],
    );
  }
}
