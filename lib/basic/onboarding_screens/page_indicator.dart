import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const PageIndicator({Key key, this.currentPage, this.pageCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _buildPageIndicators(),
    );
  }

  Widget _buildIndicator(bool isSelected) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Container(
          height: 4,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white70 : Color(0xFF3E4750),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 2),
                blurRadius: 2,
                color: Colors.black12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicators() {
    List<Widget> indicatorList = [];
    for (int i = 0; i < pageCount; i++) {
      indicatorList.add(i == currentPage ? _buildIndicator(true) : _buildIndicator(false));
    }
    return indicatorList;
  }
}
