import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:group_gallery/controllers/MainViewController.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainViewController>(
        builder: (controller) => Scaffold(
          body: IndexedStack(
            index: controller.selectedPage,
            children: controller.pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.restroom),
                label: "Room",
              ),
              BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.photoFilm),
                  label: "Gallery",
              ),
              BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.userGear),
                  label: "Profile"
              ),
            ],
            currentIndex: controller.selectedPage,
            onTap: controller.updateIndex,
            backgroundColor: Get.theme.colorScheme.onPrimary,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            selectedIconTheme: const IconThemeData(size: 28),
          ),// This trailing comma makes auto-formatting nicer for build methods.
        )
    );
  }
}
