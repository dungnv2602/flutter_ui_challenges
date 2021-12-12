/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

import 'shared.dart';

class AnimatedTitle extends StatefulWidget {
  final String title;
  final ViewState viewState;
  final double smallFontSize;
  final double largeFontSize;
  final int maxLines;
  final TextOverflow textOverflow;
  final bool isOverflow;

  const AnimatedTitle({
    Key key,
    this.title,
    this.viewState,
    this.smallFontSize = 15.0,
    this.largeFontSize = 48.0,
    this.maxLines = 2,
    this.textOverflow = TextOverflow.ellipsis,
    this.isOverflow = false,
  }) : super(key: key);

  @override
  _AnimatedTitleState createState() => _AnimatedTitleState();
}

class _AnimatedTitleState extends State<AnimatedTitle> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation fontSizeTween;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: animationDuration);

    final curve = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    double fontSizeBegin, fontSizeEnd;

    switch (widget.viewState) {
      case ViewState.enlarge:
        fontSizeBegin = widget.smallFontSize;
        fontSizeEnd = widget.largeFontSize;
        break;
      case ViewState.enlarged:
        fontSizeBegin = widget.largeFontSize;
        fontSizeEnd = widget.largeFontSize;
        break;
      case ViewState.shrink:
        fontSizeBegin = widget.largeFontSize;
        fontSizeEnd = widget.smallFontSize;
        break;
      case ViewState.shrunk:
        fontSizeBegin = widget.smallFontSize;
        fontSizeEnd = widget.smallFontSize;
        break;
    }

    fontSizeTween = Tween(
      begin: fontSizeBegin,
      end: fontSizeEnd,
    ).animate(curve);
    controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: widget.isOverflow
          ? OverflowBox(
              alignment: Alignment.topLeft,
              maxWidth: double.infinity,
              maxHeight: double.infinity,
              child: _AnimatedTitle(
                maxLines: widget.maxLines,
                title: widget.title,
                textOverflow: widget.textOverflow,
                fontSizeTween: fontSizeTween,
              ),
            )
          : _AnimatedTitle(
              maxLines: widget.maxLines,
              title: widget.title,
              textOverflow: widget.textOverflow,
              fontSizeTween: fontSizeTween,
            ),
    );
  }
}

class _AnimatedTitle extends StatelessWidget {
  final String title;
  final int maxLines;
  final TextOverflow textOverflow;
  final Animation fontSizeTween;

  const _AnimatedTitle({
    Key key,
    this.title,
    this.maxLines,
    this.textOverflow,
    this.fontSizeTween,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: fontSizeTween,
      builder: (_, __) => _TitleText(
        maxLines: maxLines,
        title: title,
        textOverflow: textOverflow,
        fontSize: fontSizeTween.value,
      ),
    );
  }
}

class _TitleText extends StatelessWidget {
  final String title;
  final int maxLines;
  final TextOverflow textOverflow;
  final double fontSize;

  const _TitleText({
    Key key,
    this.title,
    this.maxLines,
    this.textOverflow,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      overflow: textOverflow,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
    );
  }
}
