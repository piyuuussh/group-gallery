import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_gallery/bindings/main_view_binding.dart';
import 'package:group_gallery/firebase_options.dart';
import 'package:group_gallery/routes/app_pages.dart';
import 'package:group_gallery/routes/app_routes.dart';
import 'package:group_gallery/theme/color_scheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            foregroundColor: Get.theme.colorScheme.onPrimary,
            backgroundColor: Get.theme.colorScheme.primary,
            // disabledBackgroundColor: const Color.fromARGB(120, 33, 150, 243),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
        )
      ),
      // darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      initialRoute: AppRoutes.landing,
      initialBinding: MainViewBinding(),
      getPages: AppPages.pages,
    );
  }
}
