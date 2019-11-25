import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'document.dart';

typedef ChangedIndex(int index);

///加载多页后显示用，用相册模式，这样换页与缩放不会冲突
class PDFPages extends StatefulWidget {
  final ChangedIndex changedIndex;
  final PDFDocument document;

  const PDFPages({Key key, this.changedIndex, this.document}) : super(key: key);

  @override
  _PDFPagesState createState() => _PDFPagesState();
}

class _PDFPagesState extends State<PDFPages> {
  final List<String> _paths = List<String>();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  void _initPage() async {
    for (var i = 1; i <= widget.document.count; i++) {
      _paths.add(await widget.document.getPage(i));
      setState(() {_isLoading = false;});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Offstage(
          offstage: !_isLoading,
          child: Center(child: CircularProgressIndicator()),
        ),
        Offstage(
          offstage: _isLoading,
          child: PhotoViewGallery.builder(
              itemCount: widget.document.count,
              backgroundDecoration: BoxDecoration(color: Colors.white),
              onPageChanged: (index) async {
                if (widget.changedIndex != null) widget.changedIndex(index);

                if (_paths.length <= index){
                  setState(() {
                    _isLoading = true;
                  });
                }
              },
              builder: (context, index) {
                ImageProvider provider;
                if (_paths.length <= index) {
                  //加载空白图片,不加这个会在CircularProgressIndicator出来前的一瞬间出现异常
                  final emptyImgContent = Uint8List.fromList([
                    137,
                    80,
                    78,
                    71,
                    13,
                    10,
                    26,
                    10,
                    0,
                    0,
                    0,
                    13,
                    73,
                    72,
                    68,
                    82,
                    0,
                    0,
                    0,
                    1,
                    0,
                    0,
                    0,
                    1,
                    8,
                    6,
                    0,
                    0,
                    0,
                    31,
                    21,
                    196,
                    137,
                    0,
                    0,
                    0,
                    1,
                    115,
                    82,
                    71,
                    66,
                    0,
                    174,
                    206,
                    28,
                    233,
                    0,
                    0,
                    0,
                    4,
                    103,
                    65,
                    77,
                    65,
                    0,
                    0,
                    177,
                    143,
                    11,
                    252,
                    97,
                    5,
                    0,
                    0,
                    0,
                    9,
                    112,
                    72,
                    89,
                    115,
                    0,
                    0,
                    14,
                    195,
                    0,
                    0,
                    14,
                    195,
                    1,
                    199,
                    111,
                    168,
                    100,
                    0,
                    0,
                    0,
                    13,
                    73,
                    68,
                    65,
                    84,
                    24,
                    87,
                    99,
                    96,
                    96,
                    96,
                    96,
                    0,
                    0,
                    0,
                    5,
                    0,
                    1,
                    138,
                    51,
                    227,
                    0,
                    0,
                    0,
                    0,
                    0,
                    73,
                    69,
                    78,
                    68,
                    174,
                    66,
                    96,
                    130
                  ]);

                  provider = MemoryImage(emptyImgContent);
                } else {
                  provider = FileImage(File(_paths[index]));
                }
                return PhotoViewGalleryPageOptions(
                  imageProvider: provider,
                  initialScale: PhotoViewComputedScale.contained,
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 5,
                );
              }),
        ),
      ],
    );
  }
}
