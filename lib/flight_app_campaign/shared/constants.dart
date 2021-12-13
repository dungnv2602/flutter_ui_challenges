import 'package:flutter/material.dart';

const white = Color(0xFFD2C1D6);
const purple = Color(0xFF644eb2);
final purpleAccent = const Color(0xFF644eb2).withOpacity(0.5);

const redPink = Color(0xFFb95e94);
const redPurple = Color(0xFF843B65);

const flightInfoTitle = TextStyle(
  color: purple,
  fontSize: 14,
  fontWeight: FontWeight.bold,
  letterSpacing: 1,
);

const flightInfoRightValue = TextStyle(
  color: redPink,
  fontSize: 17,
  fontWeight: FontWeight.w800,
);

const smallPurple = TextStyle(
  color: purple,
);

const bigPurple = TextStyle(
  color: purple,
  fontWeight: FontWeight.bold,
  height: 1,
);

const smallGrey = TextStyle(
  color: Colors.black26,
  fontSize: 12,
  fontWeight: FontWeight.w500,
);

const bigRed = TextStyle(
  color: redPink,
  fontWeight: FontWeight.bold,
  fontSize: 38,
  height: 1.1,
);

const flightHeader = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  height: 1.4,
  shadows: [
    Shadow(
      color: Colors.black54,
      blurRadius: 16,
    ),
  ],
);

const enlargedFlightHeader = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  height: 1.4,
  shadows: [
    Shadow(
      color: Colors.black54,
      blurRadius: 16,
    ),
  ],
);

final background = TextStyle(
  letterSpacing: 30,
  fontSize: 200,
  color: white.withOpacity(0.5),
  shadows: [
    Shadow(
      color: Colors.black12,
      blurRadius: 16,
    ),
  ],
);

const flights = [
  Flight('1', 'Paris', 'France', 'New York', 'United States', 'PAR', 'LGA', 'assets/images/carousel/paris.jpg', 874),
  Flight(
      '2', 'London', 'England', 'New York', 'United States', 'ENG', 'LGA', 'assets/images/carousel/Newyork.jpg', 354),
  Flight('3', 'New York', 'United States', 'Paris', 'France', 'LGA', 'PAR', 'assets/images/carousel/london.jpg', 1283),
  Flight('4', 'Paris', 'France', 'New York', 'United States', 'PAR', 'LGA', 'assets/images/carousel/paris.jpg', 874),
  Flight(
      '5', 'London', 'England', 'New York', 'United States', 'ENG', 'LGA', 'assets/images/carousel/Newyork.jpg', 354),
  Flight('6', 'New York', 'United States', 'Paris', 'France', 'LGA', 'PAR', 'assets/images/carousel/london.jpg', 1283),
  Flight('7', 'Paris', 'France', 'New York', 'United States', 'PAR', 'LGA', 'assets/images/carousel/paris.jpg', 874),
  Flight(
      '8', 'London', 'England', 'New York', 'United States', 'ENG', 'LGA', 'assets/images/carousel/Newyork.jpg', 354),
  Flight('9', 'New York', 'United States', 'Paris', 'France', 'LGA', 'PAR', 'assets/images/carousel/london.jpg', 1283),
];

class Flight {
  final String destination;
  final String destinationCountry;
  final String source;
  final String sourceCountry;
  final String destinationCode;
  final String sourceCode;
  final String url;
  final int price;
  final String id;

  const Flight(this.id, this.destination, this.destinationCountry, this.source, this.sourceCountry,
      this.destinationCode, this.sourceCode, this.url, this.price);
}
