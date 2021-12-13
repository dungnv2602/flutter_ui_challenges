import 'package:flutter/material.dart';

import 'member_widget.dart';
import 'resources/models.dart';

class TeamMembersPage extends StatefulWidget {
  @override
  _TeamMembersPageState createState() => _TeamMembersPageState();
}

class _TeamMembersPageState extends State<TeamMembersPage> with SingleTickerProviderStateMixin {
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
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: width * 0.8,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
                .animate(CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn)),
            child: FadeTransition(
              opacity: controller,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  return MemberWidget(
                    member: members[index],
                    compactMode: false,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
