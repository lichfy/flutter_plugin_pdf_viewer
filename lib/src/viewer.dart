import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:flutter_plugin_pdf_viewer/src/pages.dart';
import 'tooltip.dart';

enum IndicatorPosition { topLeft, topRight, bottomLeft, bottomRight }

class PDFViewer extends StatefulWidget {
  final PDFDocument document;
  final Color indicatorText;
  final Color indicatorBackground;
  final IndicatorPosition indicatorPosition;
  final bool showIndicator;
  final bool showPicker;
  final PDFViewerTooltip tooltip;

  PDFViewer(
      {Key? key,
      required this.document,
      this.indicatorText = Colors.white,
      this.indicatorBackground = Colors.black54,
      this.showIndicator = true,
      this.showPicker = true,
      this.tooltip = const PDFViewerTooltip(),
      this.indicatorPosition = IndicatorPosition.topRight})
      : super(key: key);

  _PDFViewerState createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  int _pageNumber = 1;
  late PDFPages _page;

  @override
  void initState() {
    super.initState();
    _pageNumber = 1;

    _initPage();
  }

  void _initPage() async {
    _page = PDFPages(document: widget.document,changedIndex: (index){
      setState(() {
        _pageNumber = index + 1;
      });
    },);
    setState(() => {});
  }

  Widget _drawIndicator() {
    Widget child = Container(
        padding:
            EdgeInsets.only(top: 4.0, left: 16.0, bottom: 4.0, right: 16.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: widget.indicatorBackground),
        child: Text("$_pageNumber/${widget.document.count}",
            style: TextStyle(
                color: widget.indicatorText,
                fontSize: 16.0,
                fontWeight: FontWeight.w400)));

    switch (widget.indicatorPosition) {
      case IndicatorPosition.topLeft:
        return Positioned(top: 20, left: 20, child: child);
      case IndicatorPosition.topRight:
        return Positioned(top: 20, right: 20, child: child);
      case IndicatorPosition.bottomLeft:
        return Positioned(bottom: 20, left: 20, child: child);
      case IndicatorPosition.bottomRight:
        return Positioned(bottom: 20, right: 20, child: child);
      default:
        return Positioned(top: 20, right: 20, child: child);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _page,
          (widget.showIndicator)
              ? _drawIndicator()
              : Container(),
        ],
      ),
    );
  }
}
