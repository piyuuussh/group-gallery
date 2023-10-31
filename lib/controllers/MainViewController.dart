import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:group_gallery/controllers/BaseController.dart';
import 'package:group_gallery/controllers/room_controller.dart';
import 'package:group_gallery/views/gallery_page.dart';
import 'package:group_gallery/views/profile_page.dart';
import 'package:group_gallery/views/room_page.dart';
import 'package:uni_links/uni_links.dart';

class MainViewController extends BaseController{
  int _selectedIndex = 0;
  StreamSubscription? _sub;

  final RoomController _roomController = Get.find();

  @override
  void onInit() {
    super.onInit();
    int idx = Get.arguments ?? 0;
    print("arg: "+idx.toString());
    _selectedIndex = idx;
    initUniLinks();
  }


  final List<Widget> pages = [
    const RoomPage(),
    const GalleryPage(),
    const ProfilePage()
  ];

  void updateIndex(int idx){
    _selectedIndex = idx;
    update();
  }

  int get selectedPage {
    return _selectedIndex;
  }

  Future<void> initUniLinks() async{
    try {
      final Uri? uri = await getInitialUri();
      print(uri);
      redirect(uri);
      _sub = uriLinkStream.listen((Uri? uri) {
        print(uri);
        redirect(uri);
      });
    } on PlatformException {
        print("Error Occurred");
    }
  }

  void redirect(Uri? uri){
    if(uri == null) return;
    List<String> segments = uri.pathSegments;
    print(segments);
    if(segments.first == "room"){
      String roomId = segments.elementAt(1);
      if(roomId.isEmpty)  return;

      _roomController.addMemberToRoom(roomId);
    }
  }

  @override
  void onClose() async {
    await _sub!.cancel();
    super.onClose();
  }

}