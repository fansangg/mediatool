import 'package:get/get.dart';

import '../common/ui_state.dart';

class SyncState {

  late Rx<UiState> uiState;
  late Rx<int> currentIndex;

  SyncState() {
    ///Initialize variables
    uiState = UiState.loading.obs;
    currentIndex = 0.obs;
  }
}
