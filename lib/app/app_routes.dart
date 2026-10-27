class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const profile = '/profile';
  static const editProfile = '/profile/edit';
  static const settings = '/profile/settings';

  /// Path berparameter dibuat lewat fungsi, bukan string manual (Lab 8)
  static String projectDetail(String id) => '/profile/projects/$id';
}
