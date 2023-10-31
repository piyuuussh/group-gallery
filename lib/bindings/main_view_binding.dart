import 'package:get/get.dart';
import 'package:group_gallery/controllers/MainViewController.dart';
import 'package:group_gallery/controllers/auth_controller.dart';
import 'package:group_gallery/controllers/firestore_controller.dart';
import 'package:group_gallery/controllers/gallery_controller.dart';
import 'package:group_gallery/controllers/room_controller.dart';
import 'package:group_gallery/controllers/storage_controller.dart';

class MainViewBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => FirestoreController());
    Get.lazyPut(() => StorageController());
    Get.lazyPut(() => RoomController());
    Get.lazyPut(() => GalleryController());
    Get.lazyPut(() => MainViewController());
  }
}