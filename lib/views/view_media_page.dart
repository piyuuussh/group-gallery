import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_gallery/controllers/gallery_controller.dart';
import 'package:group_gallery/controllers/upload_media_controller.dart';

class ViewMediaPage extends StatelessWidget {
  const ViewMediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GalleryController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Media"),
          actions: [
            IconButton(
              onPressed: controller.shareMedia,
              icon: const Icon(Icons.share, size: 30,),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: Center(
          child: SizedBox(
            height: Get.height * 0.5,
            child: PageView.builder(
              onPageChanged: (idx) {
                controller.selectedMedia = controller.mediaList.elementAt(idx);
              },
              controller: controller.pageController,
              itemCount: controller.mediaList.length,
              itemBuilder: (context, pos) {
                return Image.network(
                  controller.mediaList.elementAt(pos).url,
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedFontSize: 14.0,
          currentIndex: 2,
          iconSize: 28,
          onTap: controller.performAction,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.download, color: Get.theme.colorScheme.primary),
              label: "Download",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.star_border,
                    color: Get.theme.colorScheme.primary),
                label: "Favourite"),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.delete_outline,
                color: Get.theme.colorScheme.primary,
              ),
              label: "Delete",
            ),
          ],
        ),
      ),
    );
  }
}
