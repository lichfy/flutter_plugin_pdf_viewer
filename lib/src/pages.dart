import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';


typedef ChangedIndex(int index);

///加载全部页后显示用，用相册模式，这样换页与缩放不会冲突
class PDFPages extends StatefulWidget {
  final List<String> paths;
  final ChangedIndex changedIndex;

  const PDFPages({Key key, this.paths, this.changedIndex}) : super(key: key);

  @override
  _PDFPagesState createState() => _PDFPagesState();
}

class _PDFPagesState extends State<PDFPages> {
  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
        itemCount: widget.paths.length,
        backgroundDecoration: BoxDecoration(color: Colors.white),
        onPageChanged: (index){
          if (widget.changedIndex != null)
            widget.changedIndex(index);
        },
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: FileImage(File(widget.paths[index])),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 5,
          );
        });
  }
}
