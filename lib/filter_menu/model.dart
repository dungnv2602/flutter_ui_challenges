import 'package:flutter/material.dart';

class FilterTask {
  const FilterTask({
    @required this.name,
    @required this.category,
    @required this.time,
    @required this.color,
    @required this.completed,
  })  : assert(name != null),
        assert(category != null),
        assert(time != null),
        assert(color != null),
        assert(completed != null);

  final String name;
  final String category;
  final String time;
  final Color color;
  final bool completed;
}

const filterTasks = [
  FilterTask(
      name: 'Catch up with Brian', category: 'Mobile Project', time: '5pm', color: Colors.orange, completed: false),
  FilterTask(name: 'Make new icons', category: 'Web App', time: '3pm', color: Colors.cyan, completed: true),
  FilterTask(
      name: 'Design explorations', category: 'Company Website', time: '2pm', color: Colors.pink, completed: false),
  FilterTask(name: 'Lunch with Mary', category: 'Grill House', time: '12pm', color: Colors.cyan, completed: true),
  FilterTask(name: 'Teem Meeting', category: 'Hangouts', time: '10am', color: Colors.cyan, completed: true),
];
