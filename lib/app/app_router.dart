import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/models.dart';
import '../pages/edit_profile_page.dart';
import '../pages/not_found_page.dart';
import '../pages/profile_page.dart';
import '../pages/project_detail_page.dart';
import '../pages/settings_page.dart';
import '../pages/splash_page.dart';
import 'app_routes.dart';

/// Router terpusat untuk named routes (Lab 5 & Pertemuan 2)
class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.splash:
        return _build(const SplashPage(), settings);

      case AppRoutes.profile:
        return _build(const ProfilePage(), settings);

      case AppRoutes.projectDetail:
        // Mendukung pengiriman objek Project (Lab 5) MAUPUN pengiriman ID string (Challenge ⭐⭐ Pertemuan 2)
        if (args is Project) {
          return _build(ProjectDetailPage(project: args), settings);
        } else if (args is String) {
          final project = findProjectById(args);
          if (project != null) {
            return _build(ProjectDetailPage(project: project), settings);
          }
        }
        return _build(const NotFoundPage(), settings);

      case AppRoutes.editProfile:
        // Periksa tipe arguments sebelum dipakai
        if (args is Profile) {
          return _build(EditProfilePage(profile: args), settings);
        }
        return _build(const NotFoundPage(), settings);

      case AppRoutes.settings:
        final initialShowBio = (args is bool) ? args : true;
        return _build(SettingsPage(initialShowBio: initialShowBio), settings);

      default:
        // Halaman 404 jika route tidak dikenali (Lab 6)
        return _build(const NotFoundPage(), settings);
    }
  }

  /// Pembungkus: `settings` wajib diteruskan agar nama route tercatat di Navigator & LogObserver
  static MaterialPageRoute<dynamic> _build(Widget page, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }
}
