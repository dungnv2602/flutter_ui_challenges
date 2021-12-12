import 'package:flutter/material.dart';

import '../common.dart';
import 'air_asia_ticket_card.dart';
import 'flight_stop_ticket.dart';

class AirAsiaTicketsPage extends StatefulWidget {
  @override
  _AirAsiaTicketsPageState createState() => _AirAsiaTicketsPageState();
}

class _AirAsiaTicketsPageState extends State<AirAsiaTicketsPage> with SingleTickerProviderStateMixin {
  static const _tickets = [
    AirAsiaFlightStopTicket('Sahara', 'SHE', 'Macao', 'MAC', 'SE2341'),
    AirAsiaFlightStopTicket('Macao', 'MAC', 'Cape Verde', 'CAP', 'KU2342'),
    AirAsiaFlightStopTicket('Cape Verde', 'CAP', 'Ireland', 'IRE', 'KR3452'),
    AirAsiaFlightStopTicket('Ireland', 'IRE', 'Sahara', 'SHE', 'MR4321'),
  ];

  AnimationController _animationController;
  List<Animation<double>> _ticketAnimations;
  Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));

    _fabAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.7, 1.0, curve: Curves.decelerate),
    );

    _ticketAnimations = _tickets.map((stop) {
      final index = _tickets.indexOf(stop);
      final intervalStart = index * 0.1;
      final intervalEnd = intervalStart + 0.6;
      return Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          intervalStart,
          intervalEnd,
          curve: Curves.decelerate,
        ),
      ));
    }).toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context).animation.status == AnimationStatus.completed) {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          const AirAsiaAppBar(),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + kToolbarHeight,
            child: SingleChildScrollView(
              child: Column(
                children: _buildTickets().toList(),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Icon(Icons.fingerprint),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Iterable<Widget> _buildTickets() {
    return _tickets.map((ticket) {
      final index = _tickets.indexOf(ticket);
      return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => FadeTransition(
          opacity: _ticketAnimations[index],
          child: Padding(
            padding: EdgeInsets.only(top: 128 - 128 * _ticketAnimations[index].value),
            child: child,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: AirAsiaTicketCard(ticket: ticket),
        ),
      );
    });
  }

  @override
  void reassemble() {
    _animationController.forward(from: 0.0);
    super.reassemble();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
