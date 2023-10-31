import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:group_gallery/controllers/BaseController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_gallery/models/firestore_room.dart';
import 'package:group_gallery/models/firestore_user.dart';


class FirestoreController extends BaseController{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String userCollection = "users";
  final String roomCollection = "rooms";

  Future<void> saveUserToDB(User? user) async {
    if(user != null){
      Map<String, dynamic> userData = FirestoreUser.fromAuthUser(user).toJson();
      await _db.collection(userCollection).doc(user.uid).set(userData);
      print("Added to Users collection");
    }
  }

  Future<void> updateUserRoom(String uid, String roomId) async{
      await _db.collection(userCollection).doc(uid).update({
        "room_id": roomId
      });
      print("Updated room id");
  }

  Future<void> updateUser(FirestoreUser user) async {
      Map<String, dynamic> userData = user.toJson();
      await _db.collection(userCollection).doc(user.uid).set(userData);
      print("User updated");
  }
  
  Future<FirestoreUser> fetchUser(String uid) async{
    DocumentSnapshot<Map<String, dynamic>> doc = await _db.collection(userCollection).doc(uid).get();
    if(!doc.exists){
      Get.snackbar("Error", "User not exist");
    }
    return FirestoreUser.fromJson(doc.data()!);
  }

  Future<void> saveRoomToDB(FirestoreRoom? room) async {
    if(room != null){
      room.updatedAt = Timestamp.now();
      Map<String, dynamic> roomData = room.toJson();
      await _db.collection(roomCollection).doc(room.roomId).set(roomData);
      print("Added to Room Collection");
    }
  }

  Future<FirestoreRoom?> fetchRoom(String roomId)async{
    DocumentSnapshot<Map<String, dynamic>> doc = await _db.collection(roomCollection).doc(roomId).get();
    if(!doc.exists){
      Get.snackbar("Error", "Room not exist");
      return null;
    }
    return FirestoreRoom.fromJson(doc.data()!);
  }

  Future<void> updateRoom(FirestoreRoom? room) async{
    if(room == null)  return;
    Map<String, dynamic> roomData = room.toJson();
    await _db.collection(roomCollection).doc(room.roomId).update(roomData);
    print("Updated Room Collection");
  }
}