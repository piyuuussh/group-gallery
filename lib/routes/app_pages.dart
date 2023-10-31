import 'package:get/get.dart';
import 'package:group_gallery/bindings/main_view_binding.dart';
import 'package:group_gallery/bindings/upload_media_view_binding.dart';
import 'package:group_gallery/routes/app_routes.dart';
import 'package:group_gallery/views/landing_page.dart';
import 'package:group_gallery/views/upload_media_page.dart';
import 'package:group_gallery/views/view_media_page.dart';

class AppPages{
  static final List<GetPage> pages = [
    GetPage(
        name: AppRoutes.landing,
        page: () => const LandingPage(),
        binding: MainViewBinding(),
    ),
    GetPage(
        name: AppRoutes.upload,
        page: () => const UploadMediaPage(),
        binding: UploadMediaViewBinding()
    ),
    GetPage(
        name: AppRoutes.view,
        page: () => const ViewMediaPage(),
        binding: UploadMediaViewBinding()
    ),
  ];
}