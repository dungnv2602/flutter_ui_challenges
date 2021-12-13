import 'package:flutter/material.dart';

class PhotoBrowser extends StatefulWidget {
  const PhotoBrowser({
    Key key,
    @required this.imgPaths,
    this.visibleIndex = 0,
  })  : assert(imgPaths != null),
        super(key: key);

  final List<String> imgPaths;
  final int visibleIndex;

  @override
  _PhotoBrowserState createState() => _PhotoBrowserState();
}

class _PhotoBrowserState extends State<PhotoBrowser> {
  int visibleIndex;

  @override
  void didUpdateWidget(PhotoBrowser oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visibleIndex != oldWidget.visibleIndex) {
      setState(() {
        visibleIndex = widget.visibleIndex;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    visibleIndex = widget.visibleIndex;
  }

  void _prevImage() {
    setState(() {
      visibleIndex = visibleIndex > 0 ? visibleIndex - 1 : 0;
    });
  }

  void _nextImage() {
    setState(() {
      visibleIndex = visibleIndex < widget.imgPaths.length - 1 ? visibleIndex + 1 : visibleIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // Photo
        Image.asset(
          widget.imgPaths[visibleIndex],
          fit: BoxFit.cover,
        ),

        // Photo indicator
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _SelectedPhotoIndicator(
            photoCount: widget.imgPaths.length,
            visibleIndex: visibleIndex,
          ),
        ),

        // Photo control
        Stack(
          fit: StackFit.expand,
          children: <Widget>[
            GestureDetector(
              onTap: _prevImage,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 1.0,
                alignment: Alignment.topLeft,
                child: Container(color: Colors.transparent),
              ),
            ),
            GestureDetector(
              onTap: _nextImage,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 1.0,
                alignment: Alignment.topRight,
                child: Container(color: Colors.transparent),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SelectedPhotoIndicator extends StatelessWidget {
  const _SelectedPhotoIndicator({Key key, @required this.photoCount, @required this.visibleIndex}) : super(key: key);

  final int photoCount;
  final int visibleIndex;

  List<Widget> _buildIndicators() {
    return List.generate(photoCount, (index) {
      return Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          height: 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.5),
            color: index == visibleIndex ? Colors.white : Colors.black.withOpacity(0.2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                spreadRadius: 0,
                blurRadius: 2,
                offset: Offset(0, 1),
              )
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(children: _buildIndicators()),
    );
  }
}
