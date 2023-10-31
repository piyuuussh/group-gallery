enum Status{
  admin,
  active,
  pending,
}

class Member{
  String uid;
  String name;
  String photoURL;
  Status status = Status.pending;

  Member(this.uid, this.name, this.photoURL, this.status);

  Map<String, dynamic> toJson(){
    return {
      "uid": uid,
      "name": name,
      "photoURL": photoURL,
      "status": status.name,
    };
  }

  factory Member.fromJson(Map<String, dynamic> json){
    return Member(json["uid"], json["name"], json["photoURL"], Status.values.byName(json["status"]));
  }
}