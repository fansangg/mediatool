import 'package:get/get_rx/src/rx_types/rx_types.dart';

class AlbumState {

  late RxInt permissionState;

  AlbumState() {
    ///Initialize variables
    permissionState = (-1).obs;
  }
}
