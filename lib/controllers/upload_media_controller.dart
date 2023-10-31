import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_gallery/controllers/BaseController.dart';
import 'package:group_gallery/controllers/auth_controller.dart';
import 'package:group_gallery/controllers/firestore_controller.dart';
import 'package:group_gallery/controllers/storage_controller.dart';
import 'package:group_gallery/models/firestore_room.dart';
import 'package:group_gallery/models/firestore_user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

class UploadMediaController extends BaseController{
  final StorageController _storageController = Get.find();
  final FirestoreController _dbController = Get.find();
  final AuthController _authController = Get.find();
  final ImagePicker imagePicker = ImagePicker();

  List<AssetEntity> mediaList = [];
  List<AssetPathEntity> albums = [];

  AssetPathEntity? selectedAlbum;
  List<AssetEntity> selectedImages = [];

  @override
  void onInit() async {
    super.onInit();
    await getAllAlbums();
  }

  Future<void> openPhotoManager() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!ps.isAuth) {
      Get.snackbar(
        "Error",
        "Permission Denied",
        mainButton: const TextButton(
          onPressed: PhotoManager.openSetting,
          child: Text("Open Settings"),
        ),
      );
      return;
    }

    await getAllAlbums();
  }

  Future<void> getAllAlbums() async{
    albums = await PhotoManager.getAssetPathList(hasAll: true);
    getMediaFromAlbum(albums.first);
  }

  Future<void> getMediaFromAlbum(AssetPathEntity album) async{
    selectedAlbum = album;
    mediaList = await album.getAssetListPaged(page: 0, size: 20);
    selectedImages = [];
    if(mediaList.isNotEmpty)  selectedImages.add(mediaList.first);
    update();
  }

  void modifySelectedImages(AssetEntity entity) {
    if(selectedImages.contains(entity)){
      selectedImages.remove(entity);
    }
    else{
      selectedImages.add(entity);
    }
    update();
  }

  Future<void> saveMedia() async{
      setState(ViewState.busy);

      User? authUser = _authController.getCurrentUser();
      FirestoreUser dbUser = await _dbController.fetchUser(authUser!.uid);
      if(dbUser.roomId == null){
        Get.snackbar("Error", "Please join or create room first");
        return;
      }

      String roomId = dbUser.roomId!;
      await Future.wait(
        selectedImages.map((e) => uploadMedia(roomId, e))
      );

      setState(ViewState.idle);
      Get.back();
  }

  Future<void> uploadMedia(String roomId, AssetEntity entity) async{
    File? file = await entity.file;
    if (file == null) {
      Get.snackbar("Error", "Error loading file");
    }

    await _storageController.uploadFile(roomId, file);
  }


  Future<void> openCamera() async{
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
  }
}