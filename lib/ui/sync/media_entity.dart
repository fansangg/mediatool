import 'dart:convert';
/// fileName : "xxx"
/// fileSize : 1233
/// path : "xxx"
/// type : 0
/// taken : 1233321
/// lastModify : 12332131
/// width : 123
/// height : 123
/// addTime : 12332131
/// uri : "xxxxxxx"
/// thumbnail : [123,123,123]

MediaEntity mediaEntityFromJson(String str) => MediaEntity.fromJson(json.decode(str));
String mediaEntityToJson(MediaEntity data) => json.encode(data.toJson());
class MediaEntity {
  MediaEntity({
      this.fileName, 
      this.fileSize, 
      this.path, 
      this.type, 
      this.taken, 
      this.lastModify, 
      this.width, 
      this.height, 
      this.addTime, 
      this.uri, 
      this.thumbnail,});

  MediaEntity.fromJson(dynamic json) {
    fileName = json['fileName'];
    fileSize = json['fileSize'];
    path = json['path'];
    type = json['type'];
    taken = json['taken'];
    lastModify = json['lastModify'];
    width = json['width'];
    height = json['height'];
    addTime = json['addTime'];
    uri = json['uri'];
    thumbnail = json['thumbnail'];
  }
  String? fileName;
  int? fileSize;
  String? path;
  int? type;
  int? taken;
  int? lastModify;
  int? width;
  int? height;
  int? addTime;
  String? uri;
  String? thumbnail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fileName'] = fileName;
    map['fileSize'] = fileSize;
    map['path'] = path;
    map['type'] = type;
    map['taken'] = taken;
    map['lastModify'] = lastModify;
    map['width'] = width;
    map['height'] = height;
    map['addTime'] = addTime;
    map['uri'] = uri;
    map['thumbnail'] = thumbnail;
    return map;
  }

  @override
  String toString() {
    return 'MediaEntity{fileName: $fileName, fileSize: $fileSize, path: $path, type: $type, taken: $taken, lastModify: $lastModify, width: $width, height: $height, addTime: $addTime, uri: $uri, thumbnail: $thumbnail}';
  }
}