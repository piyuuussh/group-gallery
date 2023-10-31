import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_gallery/models/media.dart';
import 'package:group_gallery/models/member.dart';

class FirestoreRoom{
  String roomId;
  String admin;
  List<Member> members = [];
  List<Media> mediaList = [];
  Timestamp createdAt;
  Timestamp? updatedAt;

  FirestoreRoom(this.roomId, this.admin, this.members, this.mediaList, this.createdAt, {this.updatedAt});


  factory FirestoreRoom.fromJson(Map<String, dynamic> json){
    return FirestoreRoom(
        json["room_id"],
        json["admin"],
        (json["members"] as List).map((e) => Member.fromJson(e)).toList(),
        (json["media_list"] as List).map((e) => Media.fromJson(e)).toList(),
        json["created_at"],
        updatedAt: json["updated_at"]
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "room_id": roomId,
      "admin": admin,
      "members": members.map((e) => e.toJson()).toList(),
      "media_list": mediaList.map((e) => e.toJson()).toList(),
      "created_at": createdAt,
      "updated_at": updatedAt
    };
  }


}