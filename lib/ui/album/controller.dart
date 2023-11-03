import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:media_tool/service/native_channel.dart';
import 'package:media_tool/ui/album/bean/album_bean.dart';

import 'state.dart';

class AlbumController extends GetxController {
  final AlbumState state = AlbumState();
  var albumList = <AlbumBean>[].obs;

  void getAllAlbum() async {
    var ret = await NativeChannel.instance.getAllAlbum();
    if (ret != null && ret.isNotEmpty) {
        albumList.value = ret.map((e) => AlbumBean.fromJson(e)).toList();
        Logger().d("albumList == ${albumList.length}");
    }
  }

  void getPermission() async {
    var ret = await NativeChannel.instance.requestPermission();
    Logger().d("ret == $ret");
  }

  @override
  void onReady() {
    getPermission();
    //getAllAlbum();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
