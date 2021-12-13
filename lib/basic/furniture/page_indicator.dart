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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Opacity(
        opacity: isSelected ? 1 : 0.3,
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.black54,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 2),
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
    final indicatorList = [];
    for (int i = 0; i < pageCount; i++) {
      indicatorList.add(i == currentPage ? _buildIndicator(true) : _buildIndicator(false));
    }
    return indicatorList;
  }
}
