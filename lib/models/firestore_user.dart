import 'package:firebase_auth/firebase_auth.dart';

class FirestoreUser{
  String uid;
  String name;
  String email;
  String? photoURL;
  String? roomId;

  FirestoreUser(this.uid, this.name, this.email, {this.photoURL, this.roomId});

  Map<String, dynamic> toJson(){
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "photo_url": photoURL,
      "room_id": roomId
    };
  }

  factory FirestoreUser.fromJson(Map<String, dynamic> json){
    return FirestoreUser(
      json['uid'],
      json['name'],
      json['email'],
      photoURL: json['photo_url'],
      roomId: json['room_id']
    );
  }

  factory FirestoreUser.fromAuthUser(User user){
    return FirestoreUser(
      user.uid,
      user.displayName!,
      user.email!,
      photoURL: user.photoURL,
      roomId: null
    );
  }

}