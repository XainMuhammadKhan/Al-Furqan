import 'package:alfurqan/resources/routes/route_names.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingController extends GetxController {
  Future<void> NavigateToMain() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('alreadyUsed', true);
    Get.offAllNamed(RouteNames.main);
  }
}
