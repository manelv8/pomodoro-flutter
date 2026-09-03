import 'package:flutter/foundation.dart';

class AppShellViewModel extends ChangeNotifier {
  bool _isSettingsOpen = false;

  bool get isSettingsOpen => _isSettingsOpen;

  void openSettings() {
    _isSettingsOpen = true;
    notifyListeners();
  }

  void closeSettings() {
    _isSettingsOpen = false;
    notifyListeners();
  }
}
