/// design: https://dribbble.com/shots/4908297-Flight-booking-Github-open-Source

import 'package:flutter/material.dart';

import 'common.dart';
import 'price_tab/air_asia_price_tab.dart';
import 'ticket_page/air_asia_ticket_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          const AirAsiaAppBar(),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + 40,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: const <Widget>[
                      AirAsiaRoundedButton(text: 'ONE WAY'),
                      AirAsiaRoundedButton(text: 'ROUND'),
                      AirAsiaRoundedButton(text: 'MULTICITY', selected: true),
                    ],
                  ),
                ),
                Expanded(child: AirAsiaContentCard()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AirAsiaContentCard extends StatefulWidget {
  @override
  _AirAsiaContentCardState createState() => _AirAsiaContentCardState();
}

class _AirAsiaContentCardState extends State<AirAsiaContentCard> {
  bool _showInput = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: DefaultTabController(
        length: 3,
        child: LayoutBuilder(
          builder: (BuildContext _, BoxConstraints constraints) {
            return Column(
              children: <Widget>[
                AirAsiaTabBar(),
                Expanded(
                  child: _showInput
                      ? AirAsiaMulticityInput(
                          onPressed: () {
                            setState(() => _showInput = false);
                            Navigator.of(context)
                                .push<dynamic>(MaterialPageRoute<dynamic>(builder: (_) => AirAsiaTicketsPage()));
                          },
                        )
                      : AirAsiaPriceTab(height: constraints.maxHeight - AirAsiaTabBar.tabSize),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
