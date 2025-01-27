import 'package:get/get.dart';

class LanguageController extends GetxController {
  // List of available languages
  final List<String> languages = ['EN', 'FR', 'DE', 'ES'];

  // Reactive variable for the selected language
  RxString selectedLanguage = 'EN'.obs;

  // Function to update the selected language
  void updateLanguage(String newLanguage) {
    selectedLanguage.value = newLanguage;
  }
}
