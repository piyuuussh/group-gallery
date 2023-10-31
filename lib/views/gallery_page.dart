import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_gallery/controllers/gallery_controller.dart';
import 'package:group_gallery/controllers/storage_controller.dart';
import 'package:group_gallery/models/storage_media.dart';
import 'package:group_gallery/routes/app_routes.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GalleryController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: const Text("Gallery"),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: controller.downloadMediaList,
              child: Text(
                "Download",
                style: Get.textTheme.bodyMedium!.copyWith(
                  color: controller.selectedMediaList.isNotEmpty
                      ? Get.theme.colorScheme.primary
                      : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: buildGallery(controller),
        floatingActionButton: FloatingActionButton(
          heroTag: "gallery",
          child: const Icon(Icons.upload),
          onPressed: () {
            Get.toNamed(AppRoutes.upload, arguments: controller);
          },
        ),
      ),
    );
  }

  Widget buildGallery(GalleryController controller) {
    List<StorageMedia> files = controller.mediaList;
    return SafeArea(
      child: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        header: const WaterDropHeader(),
        onRefresh: controller.refreshGallery,
        child: GridView.builder(
          itemCount: files.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemBuilder: (ctx, idx) => GestureDetector(
            onLongPress: () => controller.modifySelectedMediaList(idx),
            onTap: () {
              print(idx);
              controller.setSelectedMedia(idx);
              Get.toNamed(AppRoutes.view, arguments: idx);
            },
            child: Container(
              margin: const EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                border: controller.selectedMediaList
                    .contains(controller.mediaList.elementAt(idx))
                    ? Border.all(width: 3.0, color: Colors.blue)
                    : null,
              ),
              child: Image.network(
                files.elementAt(idx).url,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
