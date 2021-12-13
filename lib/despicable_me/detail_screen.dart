import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import 'models.dart';
import 'util.dart';

class DetailScreen extends StatefulWidget {
  final Character character;

  const DetailScreen({Key key, @required this.character}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> with SingleTickerProviderStateMixin {
  AnimationController _dragController;

  @override
  void initState() {
    super.initState();
    _dragController = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    WidgetsBinding.instance.addPostFrameCallback((_) => _afterLayout(context));
  }

  @override
  void dispose() {
    _dragController.dispose();
    super.dispose();
  }

  void _afterLayout(BuildContext context) => _dragController.forward();

  double get maxHeight => MediaQuery.of(context).size.height * 0.5;

  void _snapSheet() {
    final bool isOpen = _dragController.status == AnimationStatus.completed;
    // snap the sheet in proper direction
    _dragController.fling(velocity: isOpen ? -2 : 2);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _dragController.value -= details.primaryDelta / (maxHeight ?? details.primaryDelta);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_dragController.isAnimating || _dragController.status == AnimationStatus.completed) return;

    final double flingVelocity = details.velocity.pixelsPerSecond.dy / maxHeight;
    if (flingVelocity < 0.0)
      _dragController.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _dragController.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _dragController.fling(velocity: _dragController.value < 0.5 ? -2.0 : 2.0);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Hero(
            tag: 'background-${widget.character.name}',
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.character.colors,
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onTap: () => _dragController.reverse().then((_) => Navigator.of(context).pop()),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Hero(
                    tag: 'image-${widget.character.name}',
                    child: Image.asset(
                      widget.character.imagePath,
                      height: height * 0.45,
                    ),
                  ),
                ),
                Hero(
                  tag: 'name-${widget.character.name}',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(widget.character.name, style: TextUtils.heading),
                  ),
                ),
                Text(widget.character.description, style: TextUtils.subHeading),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: _dragController,
            builder: (_, __) => Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: lerpDouble(60, maxHeight, _dragController.value),
              child: GestureDetector(
                onTap: _snapSheet,
                onVerticalDragUpdate: _handleDragUpdate,
                onVerticalDragEnd: _handleDragEnd,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          blurRadius: 10.0,
                          spreadRadius: 4.0,
                          color: Colors.black12,
                        )
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Clips(16)', style: TextUtils.subHeading.copyWith(color: Colors.black)),
                        const SizedBox(height: 16),
                        GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: widget.character.colors.length,
                            crossAxisSpacing: 16,
                          ),
                          shrinkWrap: true,
                          itemCount: widget.character.colors.length,
                          itemBuilder: (_, index) {
                            return Container(
                              color: widget.character.colors[index],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
