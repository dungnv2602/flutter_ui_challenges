/// Implementation originated by: https://github.com/devefy/Flutter-Furniture-App-UI
/// With my own workarounds and improvements
/// Source: https://dribbble.com/shots/6091625-Furniture-mobile-app
///
import 'package:flutter/material.dart';

import 'details.dart';

const images = [
  'assets/images/basic.furniture/image_01.png',
  'assets/images/basic.furniture/image_02.png',
  'assets/images/basic.furniture/image_03.png',
];

const titles = ['Hemes ArmChair', 'Sofar ArmChari', 'Wooden ArmChair'];
const prices = ['126', '148', '179'];

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final gradientContainer = Align(
      alignment: Alignment.topRight,
      child: Container(
        width: width * 0.8,
        height: height / 2,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFf2f3f8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.5, 1.0],
          ),
        ),
      ),
    );
    final appBar = Positioned(
      top: 40,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.menu, color: Colors.black54),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
    );
    final title = Positioned(
      top: height * 0.2,
      left: 30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text('Wooden Armchair', style: TextStyle(fontSize: 28.0, fontFamily: 'Montserrat-Bold')),
          Text('Lorem Ipsum', style: TextStyle(fontSize: 16.0, fontFamily: 'Montserrat-Medium')),
        ],
      ),
    );
    final listItem = Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: height * 0.6,
        child: ListView.builder(
            itemCount: images.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 35, bottom: 60),
                child: SizedBox(
                  width: 200,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 45),
                        child: Container(
                          decoration: BoxDecoration(
                              color: index % 2 == 0 ? Colors.white : const Color(0xFF2a2d3f),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 10),
                                  blurRadius: 10,
                                  color: Colors.black12,
                                ),
                              ]),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            images[index],
                            width: 172.5,
                            height: 199.0,
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(titles[index],
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'Montserrat-Bold',
                                        color: (index % 2 == 0) ? const Color(0xFF2a2d3f) : Colors.white)),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Text('NEW SELL',
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: 'Montserrat-Medium',
                                        color: (index % 2 == 0) ? const Color(0xFF2a2d3f) : Colors.white)),
                                const SizedBox(
                                  height: 50.0,
                                ),
                                Text(prices[index] + ' \$',
                                    style: TextStyle(
                                        fontSize: 30.0,
                                        fontFamily: 'Montserrat-Bold',
                                        color: (index % 2 == 0) ? const Color(0xFF2a2d3f) : Colors.white))
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
    return Scaffold(
      backgroundColor: const Color(0xFFf2f3f8),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          gradientContainer,
          appBar,
          title,
          listItem,
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black54,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.panorama_horizontal), title: Container()),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), title: Container())
        ],
      ),
      floatingActionButton: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          color: const Color(0xFFfa7b58),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFf78a6c).withOpacity(0.6),
              offset: const Offset(0, 10),
              blurRadius: 10,
            ),
          ],
        ),
        child: RawMaterialButton(
          onPressed: () {
            /// Navigate to DetailPage
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailPage()));
          },
          shape: const CircleBorder(),
          child: Icon(
            Icons.add,
            size: 35,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
