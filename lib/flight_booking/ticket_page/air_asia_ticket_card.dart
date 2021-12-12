import 'package:flutter/material.dart';

import 'flight_stop_ticket.dart';

class _TicketClipper extends CustomClipper<Path> {
  const _TicketClipper(this.radius);

  final double radius;

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.addOval(Rect.fromCircle(center: Offset(0.0, size.height / 2), radius: radius));
    path.addOval(Rect.fromCircle(center: Offset(size.width, size.height / 2), radius: radius));
    return path;
  }

  @override
  bool shouldReclip(_TicketClipper oldClipper) => radius != oldClipper.radius;
}

class AirAsiaTicketCard extends StatelessWidget {
  const AirAsiaTicketCard({Key key, this.ticket}) : super(key: key);
  final AirAsiaFlightStopTicket ticket;

  @override
  Widget build(BuildContext context) {
    final airportNameStyle = TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600);
    final airportShortNameStyle = TextStyle(fontSize: 36.0, fontWeight: FontWeight.w200);
    final flightNumberStyle = TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500);

    return ClipPath(
      clipper: const _TicketClipper(10.0),
      child: Material(
        elevation: 4.0,
        shadowColor: const Color(0x30E5E5E5),
        color: Colors.transparent,
        child: ClipPath(
          clipper: const _TicketClipper(12.0),
          child: Card(
            elevation: 0.0,
            margin: const EdgeInsets.all(2.0),
            child: Container(
              height: 104.0,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 32.0, top: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(ticket.from, style: airportNameStyle),
                          ),
                          Text(ticket.fromShort, style: airportShortNameStyle),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Icon(
                          Icons.airplanemode_active,
                          color: Colors.red,
                        ),
                      ),
                      Text(ticket.flightNumber, style: flightNumberStyle),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0, top: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(ticket.to, style: airportNameStyle),
                          ),
                          Text(ticket.toShort, style: airportShortNameStyle),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
