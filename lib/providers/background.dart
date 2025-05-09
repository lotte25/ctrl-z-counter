import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BackgroundProvider extends ChangeNotifier {
  final Box box = Hive.box("data");

  String? _backgroundImage;
  String? _previewImage;

  String? get backgroundImage => _backgroundImage;
  String? get previewImage => _previewImage;

  BackgroundProvider() {
    _loadBackgroundImage();
  }

  void setPreview(String bg) {
    _previewImage = bg;
    notifyListeners();
  }

  void _loadBackgroundImage() {
    _backgroundImage = box.get("background");
    notifyListeners();
  }
  
  void applyBackground() async {
    if (previewImage != null) {
        _backgroundImage = previewImage;
        await box.put("background", _backgroundImage!);
        _previewImage = null;
        notifyListeners();
    }
  }

  void reset() {
    _previewImage = null;
    _backgroundImage = null;
    box.delete("background");
    notifyListeners();
  }
}