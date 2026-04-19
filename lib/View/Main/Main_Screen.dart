import 'package:alfurqan/View/Main/widgets/Custom_Navbar/Custom_Navbar.dart';
import 'package:alfurqan/ViewModel/controller/main/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MainController mainController = Get.put(MainController());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBody: true,

        body: Obx(
          () => IndexedStack(
            index: mainController.currentIndex.value,
            children: mainController.widgetList,
          ),
        ),
        bottomNavigationBar: CustomNavBar(controller: mainController),
      ),
    );
  }
}
