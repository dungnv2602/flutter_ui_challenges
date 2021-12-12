import 'package:flutter/material.dart';
import 'package:flutter_tmdb/ui_toolkit/ui_toolkit.dart';

import 'view_model.dart';

const _purple = Color(0xFF673ab7);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        backgroundColor: _purple,
        body: SafeArea(
          child: Homepage(),
        ),
      ),
    );
  }
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return InheritedStackViewController(
      itemCount: menuViewModels.length,
      reverse: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // cards
          Expanded(
            child: StackView(
              itemBuilder: (context, index) {
                final model = menuViewModels[index];

                return RotateYDecoratedStackCard(
                  backgroundColor: _purple,
                  index: index,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 16, 16, 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(36),
                      child: KeyedSubtree(
                        key: model.view.stateKey,
                        child: model.view.child,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // bottom bar
          Builder(
            builder: (context) => BottomBar(
              onLeftIcon: () {
                InheritedStackViewController.of(context).prevPage();
              },
              onRightIcon: () {
                InheritedStackViewController.of(context).nextPage();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({Key key, this.onRightIcon, this.onLeftIcon}) : super(key: key);
  final VoidCallback onRightIcon;
  final VoidCallback onLeftIcon;

  @override
  Widget build(BuildContext context) {
    final controller = InheritedStackViewController.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Center(
              child: IconButton(
                onPressed: onLeftIcon,
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: controller,
              builder: (_, __) => DashIndicator(
                height: 5.0,
                count: controller.itemCount,
                currentProgress: controller.currentPage,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: IconButton(
                onPressed: onRightIcon,
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
