import 'package:flutter/material.dart';

import '../utils/utils.dart';
import 'shared.dart';

class DetailsView extends StatefulWidget {
  final int index;
  final XdModel model;

  DetailsView({Key key, @required this.index})
      : model = models[index],
        super(key: key);

  @override
  _DetailsViewState createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> with SingleTickerProviderStateMixin {
  void _pop(BuildContext context) {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return WillPopScope(
          onWillPop: () {
            _pop(context);
            return Future.value(false);
          },
          child: Material(
            child: Stack(
              children: <Widget>[
                BackgroundHero(model: widget.model),
                TitleHero(model: widget.model),
                SubtitleHero(model: widget.model),
                Description(model: widget.model),
                Positioned(
                  bottom: constraints.maxHeight * 0.3,
                  left: constraints.maxWidth * 0.5,
                  child: FractionalTranslation(
                    translation: const Offset(-0.5, 0),
                    child: Hero(
                      tag: 'hero-avatar-${widget.model.title}',
                      child: AvatarWidget(model: widget.model),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: 32),
                    onPressed: () => _pop(context),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class BackgroundHero extends StatelessWidget {
  final XdModel model;

  const BackgroundHero({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'hero-bgrd-${model.title}',
      child: Column(
        children: <Widget>[
          Expanded(
            child: Image.asset(
              model.backgroundImgPath,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.white,
            height: 256,
          ),
        ],
      ),
    );
  }
}

class TitleHero extends StatelessWidget {
  final XdModel model;

  const TitleHero({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 180,
      left: 24,
      right: 24,
      child: Align(
        alignment: Alignment.center,
        child: HeroTextPushed(
          tag: 'hero-title-${model.title}',
          text: model.title,
          shrunkSize: 24,
          enlargedSize: 32,
          textStyle: titleStyle,
        ),
      ),
    );
  }
}

class SubtitleHero extends StatelessWidget {
  final XdModel model;

  const SubtitleHero({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 156,
      left: 24,
      right: 24,
      child: Align(
        alignment: Alignment.center,
        child: HeroTextPushed(
          tag: 'hero-collabs-${model.title}',
          text: '${model.collabs} collaborators',
          shrunkSize: 12,
          enlargedSize: 14,
          textStyle: subtitleStyle,
        ),
      ),
    );
  }
}

class Description extends StatefulWidget {
  final XdModel model;

  const Description({Key key, @required this.model}) : super(key: key);

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      left: 24,
      right: 24,
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, child) => Opacity(
          opacity: Curves.ease.transform(controller.value),
          child: Transform.translate(
            offset: Offset(0, 400 - 400 * Curves.ease.transform(controller.value)),
            child: child,
          ),
        ),
        child: Text(
          '${widget.model.desc}',
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'PlayfairDisplay',
          ),
        ),
      ),
    );
  }
}
