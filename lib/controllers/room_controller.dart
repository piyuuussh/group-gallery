import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:group_gallery/controllers/BaseController.dart';
import 'package:group_gallery/controllers/auth_controller.dart';
import 'package:group_gallery/controllers/firestore_controller.dart';
import 'package:group_gallery/models/firestore_room.dart';
import 'package:group_gallery/models/firestore_user.dart';
import 'package:group_gallery/models/member.dart';
import 'package:group_gallery/routes/app_routes.dart';
import 'package:share_plus/share_plus.dart';

class RoomController extends BaseController {
  final AuthController authController = Get.find();
  final FirestoreController dbController = Get.find();
  final TextEditingController roomTextController = TextEditingController();

  bool isLoggedIn = false;
  User? authUser;
  FirestoreUser? dbUser;
  FirestoreRoom? room;

  @override
  void onInit() async {
    super.onInit();
    authUser = authController.getCurrentUser();
    isLoggedIn = authController.isLoggedIn();
    if (isLoggedIn) {
      dbUser = await dbController.fetchUser(authUser!.uid);
      if (dbUser!.roomId != null) {
        room = await dbController.fetchRoom(dbUser!.roomId!);
        print(room!.toJson());
      }
      update();
    }
  }

  Future<void> createRoom() async {
    String roomId = generateRoomId();
    Member member = Member(authUser!.uid, authUser!.displayName!,
        authUser!.photoURL!, Status.admin);
    FirestoreRoom currentRoom =
        FirestoreRoom(roomId, authUser!.uid, [member], [], Timestamp.now());
    await dbController.saveRoomToDB(currentRoom);
    await dbController.updateUserRoom(authUser!.uid, roomId);
    Get.offAllNamed(AppRoutes.landing, arguments: 0);
  }

  Future<void> leaveRoom() async {
    authUser = authController.getCurrentUser();
    dbUser = await dbController.fetchUser(authUser!.uid);
    room = await dbController.fetchRoom(dbUser!.roomId!);
    dbUser!.roomId = null;
    dbController.updateUser(dbUser!);
    room!.members.removeWhere((element) => element.uid == authUser!.uid);
    dbController.updateRoom(room);
    Get.offAllNamed(AppRoutes.landing, arguments: 0);
  }

  Future<void> joinRoom() async {
    String scanResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", false, ScanMode.DEFAULT);
    print("ScanResult: " + scanResult);
    await addMemberToRoom(scanResult);
  }

  Future<void> addMemberToRoom(String roomId) async {
    authUser = authController.getCurrentUser();
    FirestoreRoom? currRoom = await dbController.fetchRoom(roomId);
    if (currRoom == null) return;
    Member currMember = Member(authUser!.uid, authUser!.displayName!,
        authUser!.photoURL!, Status.pending);

    FirestoreUser dbUser = await dbController.fetchUser(authUser!.uid);
    if (dbUser.roomId != null) {
      Get.snackbar("Error", "Please leave previous room first");
      return;
    }
    currRoom.members.add(currMember);
    await dbController.updateRoom(currRoom);
    await dbController.updateUserRoom(authUser!.uid, roomId);
    Get.offAllNamed(AppRoutes.landing, arguments: 0);
  }

  String generateRoomId() {
    String id = "";
    for (int i = 0; i < 4; i++) {
      id += generate4RandomCharacters();
      if (i != 3) id += "-";
    }
    return id;
  }

  String generate4RandomCharacters() {
    var r = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return List.generate(4, (index) => chars[r.nextInt(chars.length)]).join();
  }

  Future<List<Member>> getCurrentMembers() async {
    authUser = authController.getCurrentUser();
    dbUser = await dbController.fetchUser(authUser!.uid);
    room = await dbController.fetchRoom(dbUser!.roomId!);
    return room!.members;
  }

  Future<void> shareRoom() async {
    if (room == null) {
      Get.snackbar("Error", "Please join room first!");
      return;
    }
    String url = "asmit://group.gallery/room/${room!.roomId}";
    await Share.share(url);
  }

  Chip getChip(Member member){
    Color backgroundColor = Colors.green;
    switch(member.status){
      case Status.admin:
        backgroundColor = Get.theme.colorScheme.primary;
      case Status.pending:
        backgroundColor = Colors.deepOrange;
      default:
        backgroundColor = Colors.green;
    }


    return Chip(
      label: Text(member.status.name.toUpperCase()),
      backgroundColor: backgroundColor,
      labelStyle: Get.textTheme.bodyMedium!.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  void buildBottomSheet() async {
    List<Member> members = await getCurrentMembers();
    Get.bottomSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          Text("Current Members", style: Get.textTheme.bodyLarge),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (ctx, idx) {
                Member member = members.elementAt(idx);
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(member.photoURL),
                  ),
                  title: Text(member.name),
                  trailing: getChip(member),
                );
              },
            ),
          )
        ],
      ),
      backgroundColor: Get.theme.colorScheme.onPrimary,
      enableDrag: true,
      isDismissible: true,
    );
  }
}
