import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_buddy_goo_mobile/common/widgets/network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'common_widgets.dart';

class PhotoViewPage extends StatefulWidget {
  const PhotoViewPage({super.key});

  @override
  _PhotoViewPageState createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  List<String>? images;

  @override
  void initState() {
    super.initState();
    images = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Image Viewer",
            style: Theme.of(context)
                .textTheme
                .headline4
                ?.copyWith(color: Colors.white)),
      ),
      body: Container(
        child: images == null
            ? const LoadingWidget(color: Colors.white)
            : PhotoViewGallery.builder(
                itemCount: images?.length,
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    minScale: PhotoViewComputedScale.contained * 0.95,
                    maxScale: PhotoViewComputedScale.covered * 1.75,
                    imageProvider:
                        NetworkImage(backendServerUrlImage + images![index]),
                    initialScale: PhotoViewComputedScale.contained,
                    heroAttributes:
                        PhotoViewHeroAttributes(tag: images![index]),
                  );
                },
                loadingBuilder: (context, event) => Center(
                  child: SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      value: event == null
                          ? 0
                          : event.cumulativeBytesLoaded /
                              event.expectedTotalBytes!,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
