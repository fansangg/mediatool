import 'dart:convert';
/// albumName : "所有照片"
/// count : 0
/// firstImg : ""

AlbumBean albumBeanFromJson(String str) => AlbumBean.fromJson(json.decode(str));
String albumBeanToJson(AlbumBean data) => json.encode(data.toJson());
class AlbumBean {
  AlbumBean({
      this.albumName, 
      this.count, 
      this.firstImg,});

  AlbumBean.fromJson(dynamic json) {
    albumName = json['albumName'];
    count = json['count'];
    firstImg = json['firstImg'];
  }
  String? albumName;
  int? count;
  String? firstImg;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['albumName'] = albumName;
    map['count'] = count;
    map['firstImg'] = firstImg;
    return map;
  }

}