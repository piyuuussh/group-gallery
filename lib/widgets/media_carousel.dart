import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

Widget PostCarousel(List<AssetEntity> mediaList){
  final RxInt currentPage = 0.obs;

  return Container(
    padding: const EdgeInsets.all(3.0),
    width: double.infinity,
    height: Get.size.height * 0.4,
    child: PageView.builder(
      onPageChanged: (int idx) {
        currentPage.value = idx;
      },
      itemCount: mediaList.length,
      pageSnapping: true,
      itemBuilder: (context, pos) {
        return SizedBox(
          height: Get.width - 50,
          // child: buildMedia(post.media![pos]),
          child: AssetEntityImage(
            mediaList[pos],
            fit: BoxFit.cover,
          ),
        );
      },
    ),
  );
}