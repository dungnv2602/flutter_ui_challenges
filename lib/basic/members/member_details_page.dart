import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

import 'image_hero.dart';
import 'resources/models.dart';
import 'resources/sizes.dart';
import 'resources/text_styles.dart';

class MemberDetailsPage extends StatefulWidget {
  final Member member;
  final PaletteGenerator palette;

  const MemberDetailsPage({Key key, @required this.member, this.palette}) : super(key: key);

  @override
  _MemberDetailsPageState createState() => _MemberDetailsPageState();
}

class _MemberDetailsPageState extends State<MemberDetailsPage> with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final names = widget.member.name.split(' ');

    return Scaffold(
      body: Stack(
        children: <Widget>[
          ImageHero(
            tag: widget.member.name,
            imagePath: widget.member.imagePath,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fitHeight,
            onTap: () {},
          ),
          Container(
            color: widget.palette.darkMutedColor.color.withOpacity(0.8),
          ),
          Positioned(
            top: size_60,
            right: size_20,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
                size: size_40,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: size_40, right: size_20, bottom: size_20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: size_120,
                ),
                Text(names[0], style: nameBigStyle.copyWith(color: widget.palette.lightMutedColor.color)),
                Text(names[1], style: nameBigStyle.copyWith(color: widget.palette.lightMutedColor.color)),
                SizedBox(height: size_8),
                Text(widget.member.occupation,
                    style: descriptionBoldStyle.copyWith(color: widget.palette.lightMutedColor.color)),
                const SizedBox(height: size_20),
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    child: Text(widget.member.description, style: descriptionStyle),
                  ),
                ),
                const SizedBox(height: size_20),
                Text('Our Team Members'.toUpperCase(), style: descriptionBoldStyle),
                SizedBox(height: size_8),
                Container(
                  height: size_100,
                  child: SlideTransition(
                    position: Tween<Offset>(begin: const Offset(2, 0), end: const Offset(0, 0))
                        .animate(CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn)),
                    child: FadeTransition(
                      opacity: controller,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                height: 100,
                                width: 80,
                                child: Material(
                                  child: InkWell(
                                    onTap: () {},
                                    child: Image.asset(
                                      members[index].imagePath,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(width: size_12);
                          },
                          itemCount: members.length),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
