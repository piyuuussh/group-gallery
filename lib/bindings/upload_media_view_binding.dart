import 'package:get/get.dart';
import 'package:group_gallery/controllers/auth_controller.dart';
import 'package:group_gallery/controllers/firestore_controller.dart';
import 'package:group_gallery/controllers/storage_controller.dart';
import 'package:group_gallery/controllers/upload_media_controller.dart';

class UploadMediaViewBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => StorageController());
    Get.lazyPut(() => FirestoreController());
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => UploadMediaController());
  }
}