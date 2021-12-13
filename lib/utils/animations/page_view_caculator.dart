import 'dart:math' as math;

import 'package:flutter/material.dart';

// WITH INDEX
double calculateTweenWithIndex({@required int index, @required PageController controller, double velocity = 1.0}) {
  final currentPage = calculateCurrentPage(controller);

  final respectiveDistance = currentPage - index;

  return (1 - velocity * respectiveDistance.abs()).clamp(0.0, 1.0);
}

double calculatePowTweenWithIndex({@required int index, @required PageController controller, double velocity = 30.0}) {
  final currentPage = calculateCurrentPage(controller);

  final respectiveDistance = currentPage - index;

  return math.pow(2, -velocity * respectiveDistance.abs());
}

double calculateGaussTweenWithIndex({@required int index, @required PageController controller, double velocity = 1.0}) {
  final currentPage = calculateCurrentPage(controller);

  final respectiveDistance = currentPage - index;

  return math.exp(-(math.pow(respectiveDistance.abs() - 0.5, 2) / 0.08)) * velocity;
}

double calculateTranslateGaussTweenWithIndex(
    {@required int index, @required PageController controller, double velocity = 32.0}) {
  final currentPage = calculateCurrentPage(controller);

  final respectiveDistance = currentPage - index;

  return math.exp(-(math.pow(respectiveDistance.abs() - 0.5, 2) / 0.08)) * respectiveDistance.sign * -velocity;
}

// WITHOUT INDEX
double calculateTween({@required PageController controller, double velocity = 1.0}) {
  final currentPage = calculateCurrentPage(controller);

  final respectiveDistance = calculateRespectiveDistance(currentPage);

  return (1 - velocity * respectiveDistance.abs()).clamp(0.0, 1.0);
}

double calculatePowTween({@required PageController controller, double velocity = 50.0}) {
  final currentPage = calculateCurrentPage(controller);

  final respectiveDistance = calculateRespectiveDistance(currentPage);

  return math.pow(2, -velocity * respectiveDistance.abs());
}

double calculateTranslateGaussTween({@required PageController controller, double velocity = 32.0}) {
  final currentPage = calculateCurrentPage(controller);

  final respectiveDistance = calculateRespectiveDistance(currentPage);

  return math.exp(-(math.pow(respectiveDistance.abs() - 0.5, 2) / 0.08)) * respectiveDistance.sign * -velocity;
}

double calculateCurrentPage(PageController controller) {
  return (!controller.hasClients || controller.offset == null || controller.offset <= 0)
      ? controller.initialPage.toDouble()
      : controller.page;
}

double calculateRespectiveDistance(double currentPage) {
  return currentPage - currentPage.round();
}
