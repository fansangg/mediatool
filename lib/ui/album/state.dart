import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../common/ui_state.dart';

class AlbumState {

  late Rx<UiState> uiState;

  AlbumState() {
    ///Initialize variables
    uiState = UiState.loading.obs;
  }
}
