import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_gallery/controllers/BaseController.dart';
import 'package:group_gallery/controllers/auth_controller.dart';
import 'package:group_gallery/controllers/firestore_controller.dart';
import 'package:group_gallery/controllers/storage_controller.dart';
import 'package:group_gallery/models/firestore_user.dart';
import 'package:group_gallery/models/storage_media.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class GalleryController extends BaseController {
  final RefreshController refreshController = RefreshController();
  final AuthController _authController = Get.find();
  final FirestoreController _dbController = Get.find();
  final StorageController _storageController = Get.find();
  PageController? pageController;

  List<StorageMedia> mediaList = [];
  StorageMedia? selectedMedia;
  List<StorageMedia> selectedMediaList = [];
  int selectedIndex = 0;

  List<Function> actions = [];

  @override
  void onInit() async {
    super.onInit();
    await refreshGallery();
    actions = [
      downloadMedia,
    ];
  }

  Future<void> refreshGallery() async{
    User? authUser = _authController.getCurrentUser();
    if (authUser == null) return;
    FirestoreUser? dbUser = await _dbController.fetchUser(authUser!.uid);
    if(dbUser.roomId == null) return;

    mediaList = await _storageController.listFiles(dbUser.roomId!);
    if(mediaList.isNotEmpty){
      selectedMedia = mediaList.first;
      selectedIndex = 0;
      pageController = PageController(initialPage: selectedIndex);
    }
    refreshController.refreshCompleted();
    update();
  }

  void setSelectedMedia(int idx){
    selectedMedia = mediaList.elementAt(idx);
    selectedIndex = idx;
    pageController = PageController(initialPage: selectedIndex);
    update();
  }

  void modifySelectedMediaList(idx){
    StorageMedia media = mediaList.elementAt(idx);
    if(selectedMediaList.contains(media)){
      selectedMediaList.remove(media);
    }
    else{
      selectedMediaList.add(media);
    }
    print(selectedMediaList);
    update();
  }

  void performAction(int idx) {
    actions.elementAt(idx)();
  }

  Future<XFile?> downloadMedia() async{
    if(selectedMedia == null){
      Get.snackbar("Error", "No Media Selected");
      return null;
    }
    Directory? dir = await getDownloadsDirectory();
    if(dir == null){
      Get.snackbar("Error", "Directory not found");
    }
    String fileName = '${dir!.path}/${selectedMedia!.metadata.name}.png';
    print(selectedMedia!.url);
    final http.Response response = await http.get(Uri.parse(selectedMedia!.url));
    final File file = await File(fileName).create(recursive: true);
    await file.writeAsBytes(response.bodyBytes);
    
    final result = await ImageGallerySaver.saveFile(file.path, isReturnPathOfIOS: Platform.isIOS);

    print(result);
    Get.snackbar("Success", "Image saved successfully!");
    return XFile(file.path);
  }

  Future<void> downloadMediaForList(StorageMedia media) async{
    Directory? dir = await getTemporaryDirectory();
    if(dir == null){
      Get.snackbar("Error", "Directory not found");
    }
    String fileName = '${dir!.path}/${media!.metadata.name}.png';
    final http.Response response = await http.get(Uri.parse(media!.url));
    final File file = await File(fileName).create(recursive: true);
    await file.writeAsBytes(response.bodyBytes);

    final result = await ImageGallerySaver.saveFile(file.path, isReturnPathOfIOS: Platform.isIOS);

    print(result);
    Get.snackbar("Success", "Image saved successfully!");
  }

  Future<void> downloadMediaList() async{
    if(selectedMediaList.isEmpty) return;
    await Future.wait(
      selectedMediaList.map((e) async => await downloadMediaForList(e))
    );
  }

  Future<void> shareMedia() async{
    XFile? file = await downloadMedia();
    if(file == null)  return;
    await Share.shareXFiles([file]);
  }
}
