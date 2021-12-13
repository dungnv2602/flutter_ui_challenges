import 'package:flutter/material.dart';

class Page extends StatelessWidget {
  final PageViewModel viewModel;
  final double percentVisible;

  const Page({
    this.viewModel,
    this.percentVisible = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: viewModel.color,
      child: Opacity(
        opacity: percentVisible,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform(
              transform: Matrix4.translationValues(
                0.0,
                50.0 * (1.0 - percentVisible),
                0.0,
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: viewModel.image,
              ),
            ),
            Transform(
              transform: Matrix4.translationValues(
                0.0,
                30.0 * (1.0 - percentVisible),
                0.0,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: viewModel.title,
              ),
            ),
            Transform(
              transform: Matrix4.translationValues(
                0.0,
                30.0 * (1.0 - percentVisible),
                0.0,
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 75.0),
                child: viewModel.body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageViewModel {
  final Color color;
  final Widget image;
  final Text title;
  final Text body;
  final Widget indicatorIcon;

  const PageViewModel({
    @required this.color,
    @required this.image,
    this.title,
    this.body,
    this.indicatorIcon,
  })  : assert(color != null),
        assert(image != null);
}
