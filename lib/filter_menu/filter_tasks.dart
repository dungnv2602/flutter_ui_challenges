import 'package:flutter/material.dart';

import 'filter_menu.dart';

class FilterTasks extends StatelessWidget {
  static final animatedTasksModel = FilterTasksListModel<FilterTask>(
    initialItems: filterTasks,
    removedItemBuilder: (_, __, task, animation) => TaskRow(task: task, animation: animation),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: MainPage.headerHeight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Tasks Header
          Padding(
            padding: const EdgeInsets.only(left: MainPage.paddingLeft * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text('My Tasks'),
                SizedBox(height: 8),
                Text('FEBRUARY 8, 2020'),
              ],
            ),
          ),
          // Tasks List
          Expanded(
            child: AnimatedList(
              physics: const BouncingScrollPhysics(),
              key: animatedTasksModel.listKey,
              initialItemCount: animatedTasksModel.length,
              itemBuilder: (_, index, animation) => TaskRow(task: animatedTasksModel[index], animation: animation),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class TaskRow extends StatelessWidget {
  const TaskRow({
    Key key,
    @required this.task,
    @required this.animation,
  })  : assert(task != null),
        assert(animation != null),
        super(key: key);

  final FilterTask task;
  final Animation<double> animation;

  static const dotSize = 12.0;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: MainPage.paddingLeft - TaskRow.dotSize / 2), // center of timeline
                child: Container(
                  height: TaskRow.dotSize,
                  width: TaskRow.dotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: task.color,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(task.name),
                    Text(task.category),
                  ],
                ),
              ),
              Text(task.time),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}
