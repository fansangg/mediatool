import 'package:get/get.dart';

import '../common/ui_state.dart';

class SyncState {

  late Rx<UiState> uiState;

  SyncState() {
    ///Initialize variables
    uiState = UiState.loading.obs;
  }
}
