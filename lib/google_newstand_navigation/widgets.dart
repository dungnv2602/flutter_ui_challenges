import 'package:flutter/material.dart';

import 'sections.dart';

const kSectionIndicatorWidth = 32.0;

/// The title is rendered with two overlapping text widgets that are vertically
/// offset a little. It's supposed to look sort-of 3D.
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key key,
    @required this.section,
    @required this.scale,
    @required this.opacity,
  })  : assert(section != null),
        assert(scale != null),
        assert(opacity != null && opacity >= 0.0 && opacity <= 1.0),
        super(key: key);

  final Section section;
  final double scale;
  final double opacity;

  static const TextStyle sectionTitleStyle = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 24.0,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static final TextStyle sectionTitleShadowStyle = sectionTitleStyle.copyWith(
    color: const Color(0x19000000),
  );

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: opacity,
        child: Transform(
          transform: Matrix4.identity()..scale(scale),
          alignment: Alignment.center,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 4.0,
                child: Text(section.title, style: sectionTitleShadowStyle),
              ),
              Text(section.title, style: sectionTitleStyle),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  const SectionCard({Key key, @required this.section})
      : assert(section != null),
        super(key: key);

  final Section section;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            section.leftColor,
            section.rightColor,
          ],
        ),
      ),
      child: Image.asset(
        section.backgroundAsset,
        package: section.backgroundAssetPackage,
        color: const Color.fromRGBO(255, 255, 255, 0.075), // image opacity
        colorBlendMode: BlendMode.modulate, // image opacity
        fit: BoxFit.cover,
      ),
    );
  }
}

/// Small horizontal bar that indicates the selected section.
class SectionIndicator extends StatelessWidget {
  const SectionIndicator({Key key, this.opacity}) : super(key: key);
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: kSectionIndicatorWidth,
        height: 3,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}

/// Display a single SectionDetail.
class SectionDetailItemView extends StatelessWidget {
  const SectionDetailItemView({
    Key key,
    @required this.detailItem,
    this.imageOnly = false,
  })  : assert(detailItem != null),
        super(key: key);
  final SectionDetailItem detailItem;

  final bool imageOnly;

  @override
  Widget build(BuildContext context) {
    final image = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        image: DecorationImage(
          image: AssetImage(
            detailItem.imageAsset,
            package: detailItem.imageAssetPackage,
          ),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
    );

    Widget item;

    if (imageOnly) {
      item = Container(
        height: 240,
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          top: false,
          bottom: false,
          child: image,
        ),
      );
    } else {
      item = ListTile(
        title: Text(detailItem.title),
        subtitle: Text(detailItem.subtitle),
        leading: SizedBox(width: 32, height: 32, child: image),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child: item,
    );
  }
}
