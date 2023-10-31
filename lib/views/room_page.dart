import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_gallery/controllers/room_controller.dart';
import 'package:group_gallery/models/member.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RoomPage extends StatelessWidget {
  const RoomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RoomController>(
      builder: (controller) => controller.room == null
          ? buildWithoutRoomWidgets(controller)
          : buildWithRoomWidgets(controller),
    );
  }

  Widget buildWithoutRoomWidgets(RoomController controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: controller.createRoom,
          child: const Text("Create Room"),
        ),
        const SizedBox(height: 10),
        const Divider(thickness: 2.0),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            controller: controller.roomTextController,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              hintText: "ABCD-EFGH-IJKL-MNOP",
            ),
            onChanged: (text){
              controller.roomTextController.text = text.toUpperCase();
            },
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => controller.addMemberToRoom(controller.roomTextController.text),
          child: const Text("Join Room"),
        ),
        const SizedBox(height: 30),
        ElevatedButton.icon(
          onPressed: controller.joinRoom,
          label: const Text("Scan QR"),
          icon: const Icon(Icons.qr_code),
        ),
      ],
    );
  }

  Widget buildWithRoomWidgets(RoomController controller) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Your Room", style: Get.textTheme.headlineMedium),
            const SizedBox(height: 20),
            QrImageView(
              data: controller.room!.roomId,
              size: 250,
            ),
            const SizedBox(height: 20),
            Text(controller.room!.roomId),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.buildBottomSheet,
              child: const Text("View Members"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.leaveRoom,
              child: const Text("Leave Group"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.shareRoom,
        child: const Icon(Icons.share),
      ),
    );
  }
}
