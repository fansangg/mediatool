import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../common/ui_state.dart';

class ExifState {
  
  late Rx<UiState> uiState;
  
  ExifState() {
    uiState = UiState.loading.obs;
  }
}
