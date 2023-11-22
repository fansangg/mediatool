import 'package:get/get.dart';

import '../common/ui_state.dart';

class SyncState {

  late Rx<UiState> uiState;
  late Rx<int> currentIndex;
  late RxMap<dynamic,dynamic> processMap;

  SyncState() {
    ///Initialize variables
    uiState = UiState.loading.obs;
    currentIndex = 0.obs;
    processMap = {}.obs;
  }
}
