// Keeps a Dart [List] in sync with an [AnimatedList].
//
// The [insert] and [removeAt] methods apply to both the internal list and
// the animated list that belongs to [listKey].
//
// This class only exposes as much of the Dart List API as is needed by the
// sample app. More list methods are easily added, however methods that
// mutate the list must make the same changes to the animated list in terms
// of [AnimatedListState.insertItem] and [AnimatedList.removeItem].
import 'package:flutter/material.dart';
import 'package:flutter_tmdb/ui_toolkit/ui_toolkit.dart';

// Used to build an item after it has been removed from the list. This
// method is needed because a removed item remains visible until its
// animation has completed (even though it's gone as far this ListModel is
// concerned).
typedef FilterTasksRemovedItemBuilder<T> = Widget Function(
  BuildContext context,
  int index,
  T removedItem,
  Animation<double> animation,
);

class FilterTasksListModel<T> {
  FilterTasksListModel({
    @required this.removedItemBuilder,
    Iterable<T> initialItems,
  })  : assert(removedItemBuilder != null),
        _items = List<T>.from(initialItems ?? <T>[]);

  final FilterTasksRemovedItemBuilder<T> removedItemBuilder;
  final List<T> _items;

  final _listKey = GlobalKey<SliverAnimatedListState>();
  GlobalKey<SliverAnimatedListState> get listKey => _listKey;
  SliverAnimatedListState get _animatedList => _listKey.currentState;

  static const insertItemDuration = MotionDurations.mediumIn;
  static const removeItemDuration = MotionDurations.mediumOut;

  void insertFirst(T item) => _insert(0, item);
  void insertLast(T item) => _insert(_items.length, item);

  void _insert(int index, T item) {
    _items.insert(index, item);
    if (_animatedList != null) _animatedList.insertItem(index, duration: insertItemDuration);
  }

  int remove(T item) {
    final index = _items.indexOf(item);
    removeAt(index);
    return index;
  }

  T removeAt(int index) {
    final T removedItem = _items.removeAt(index);
    if (_animatedList != null && removedItem != null) {
      _animatedList.removeItem(
        index,
        (BuildContext context, Animation<double> animation) =>
            removedItemBuilder(context, index, removedItem, animation),
        duration: Duration(
            milliseconds:
                (removeItemDuration.inMilliseconds + removeItemDuration.inMilliseconds * (index / length)).truncate()),
      );
    }
    return removedItem;
  }

  int get length => _items.length;

  T operator [](int index) => _items[index];

  int indexOf(T item) => _items.indexOf(item);

  bool contains(T item) => _items.contains(item);

  bool get isNotEmpty => length > 0;

  Iterable<E> map<E>(E Function(T t) func) => _items.map<E>(func);

  void clear() => _items.clear();
}
