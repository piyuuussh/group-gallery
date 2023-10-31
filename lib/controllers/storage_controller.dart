
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:group_gallery/models/storage_media.dart';
import 'package:uuid/uuid.dart';

class StorageController extends GetxController{
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid uuid = const Uuid();
  String? nextPageToken;
  int limit = 30;

  Future<StorageMedia> getFile(String roomId, String fileId) async{
    Reference ref =  _storage.ref().child(roomId).child(fileId);
    String url = await ref.getDownloadURL();
    FullMetadata metadata = await ref.getMetadata();
    StorageMedia media = StorageMedia(url, metadata);
    return media;
  }

  Future<void> uploadFile(String roomId, File? file) async{
    if(file == null){
      Get.snackbar("Error", "Empty file upload");
    }
    String fileId = uuid.v4();
    UploadTask task = _storage.ref().child(roomId).child(fileId).putFile(file!);
    task.whenComplete(() => Get.snackbar("Success", "File Uploaded Successfully"));
  }

  Future<List<StorageMedia>> listFiles(String roomId) async{
    ListOptions options = ListOptions(maxResults: limit, pageToken: nextPageToken);
    ListResult result = await _storage.ref().child(roomId).list(options);
    nextPageToken = result.nextPageToken;

    Iterable<Future<StorageMedia>> iterable = result.items.map((e) async => await getFile(roomId, e.name));
    List<StorageMedia> files = await Future.wait(iterable);
    print("files here");
    print(files.length);
    return files;
  }
}