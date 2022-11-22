import 'package:flutter/material.dart';
// import 'package:go_buddy_goo/configs/backendUrl.dart';

// const String backendServerUrlImage = "https://sbteam.c4cdev.live";
// const String backendServerUrlImage = "https://vendor.gobuddygoo.com";
const String backendServerUrlImage = "https://test-gbg.ktm.yetiappcloud.com/";

Widget showNetworkImage(String url) {
  return FadeInImage.assetNetwork(
    image: url.contains("http") ? url : backendServerUrlImage + url,
    placeholder: "assets/images/loading.gif",
    fit: BoxFit.cover,
  );
}

Widget showNetworkImageNoFit(String url) {
  return FadeInImage.assetNetwork(
    image: url.contains("http") ? url : backendServerUrlImage + url,
    placeholder: "assets/images/loading.gif",
    // fit: BoxFit.fitHeight,
  );
}

Widget showNetworkImageSmall(String url) {
  return Center(
    child: FadeInImage.assetNetwork(
      image: url.contains("http") ? url : backendServerUrlImage + url,
      placeholder: "assets/images/loading.gif",
      fit: BoxFit.cover,
    ),
  );
}

Widget showNetworkImageSmallCircular(String url) {
  return Container(
    height: 50,
    width: 50,
    clipBehavior: Clip.antiAlias,
    decoration: const BoxDecoration(shape: BoxShape.circle),
    child: FadeInImage.assetNetwork(
      image: url.contains("http") ? url : backendServerUrlImage + url,
      placeholder: "assets/images/loading.gif",
      fit: BoxFit.cover,
    ),
  );
}

// DecorationImage showDecorationImage(String url) {
//   var image = NetworkImage(url);
//   return DecorationImage(
//       image: image,
//       onError: (_, __) {
//         setState();
//       });
// }
