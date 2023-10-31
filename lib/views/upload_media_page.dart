import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_gallery/controllers/upload_media_controller.dart';
import 'package:group_gallery/widgets/post_carousel.dart';
import 'package:photo_manager/photo_manager.dart';

class UploadMediaPage extends StatelessWidget {
  const UploadMediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UploadMediaController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: Get.back,
            child: const Icon(
              Icons.close,
              size: 35,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: controller.saveMedia,
              child: Text("Upload",
                  style: Get.textTheme.bodyLarge!.copyWith(color: Colors.blue)),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostCarousel(controller.selectedImages),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton<AssetPathEntity>(
                      value: controller.selectedAlbum,
                      onChanged: (AssetPathEntity? value) {
                        controller.getMediaFromAlbum(value!);
                      },
                      items: controller.albums
                          .map(
                            (AssetPathEntity album) => DropdownMenuItem(
                              value: album,
                              child: Text(album.name),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  IconButton(
                    onPressed: controller.openCamera,
                    icon: const Icon(Icons.camera_alt),
                    color: Get.theme.colorScheme.primary,
                    iconSize: 28,
                  )
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: controller.mediaList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      controller
                          .modifySelectedImages(controller.mediaList[index]);
                    },
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              border: controller.selectedImages
                                      .contains(controller.mediaList[index])
                                  ? Border.all(width: 3.0, color: Colors.blue)
                                  : null,
                            ),
                            child: AssetEntityImage(
                              controller.mediaList[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (controller.mediaList[index].type == AssetType.video)
                          const Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 5, bottom: 5),
                              child: Icon(
                                Icons.videocam,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
