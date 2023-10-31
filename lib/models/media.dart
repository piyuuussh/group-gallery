class Media{
  String userId;
  String url;
  String createdAt;

  Media(this.userId, this.url, this.createdAt);

  factory Media.fromJson(Map<String, dynamic> json){
    return Media(json["userId"], json["url"], json["createdAt"]);
  }

  Map<String, dynamic> toJson(){
    return {
      "userId": userId,
      "url": url,
      "createdAt": createdAt
    };
  }

}