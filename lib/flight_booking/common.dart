import 'package:flutter/material.dart';

class AirAsiaMulticityInput extends StatelessWidget {
  const AirAsiaMulticityInput({Key key, this.onPressed}) : super(key: key);
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 64, 8),
              child: TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.flight_takeoff, color: Colors.red),
                  labelText: 'From',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 64, 8),
              child: TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.flight_land, color: Colors.red),
                  labelText: 'To',
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.flight_land, color: Colors.red),
                        labelText: 'To',
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 64,
                  alignment: Alignment.center,
                  child: Icon(Icons.add_circle_outline, color: Colors.grey),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 64, 8),
              child: TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.person, color: Colors.red),
                  labelText: 'Passengers',
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(Icons.date_range, color: Colors.red),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Departure'),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Arrival'),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            FloatingActionButton(
              onPressed: onPressed,
              child: const Icon(Icons.timeline, size: 36),
            ),
          ],
        ),
      ),
    );
  }
}

class AirAsiaRoundedButton extends StatelessWidget {
  const AirAsiaRoundedButton({Key key, this.text, this.selected = false, this.onTap}) : super(key: key);

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = selected ? Colors.white : Colors.transparent;
    final textColor = selected ? Colors.red : Colors.white;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(child: Text(text, style: TextStyle(color: textColor))),
          ),
        ),
      ),
    );
  }
}

class AirAsiaTabBar extends StatelessWidget {
  static const tabSize = 48.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          top: null,
          child: Container(
            height: 2,
            color: const Color(0xFFEEEEEE),
          ),
        ),
        TabBar(
          tabs: const [
            Tab(text: 'Flight'),
            Tab(text: 'Train'),
            Tab(text: 'Bus'),
          ],
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
        ),
      ],
    );
  }
}

class AirAsiaAppBar extends StatelessWidget {
  const AirAsiaAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: const [Colors.red, Color(0xFFE64C85)],
            ),
          ),
          height: 220,
        ),
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text('AirAsia', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
