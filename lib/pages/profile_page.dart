import 'package:flutter/material.dart';
import '../app/app_routes.dart';
import '../data/dummy_data.dart';
import '../models/models.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Profile _profile = defaultProfile;
  bool _showBio = true; // Terhubung dengan Challenge ⭐ Pertemuan 2 (Settings)

  /// Navigasi ke Detail Proyek (Lab 5 & Challenge ⭐⭐ Pertemuan 2)
  void _openProjectDetail(Project project) {
    // Mengirim ID proyek sebagai argument string (Challenge ⭐⭐ Pertemuan 2)
    Navigator.pushNamed(
      context,
      AppRoutes.projectDetail,
      arguments: project.id,
    );
  }

  /// Navigasi ke Edit Profil dan tangkap hasilnya (Lab 3, Lab 5 & Challenge ⭐⭐ Pertemuan 1)
  Future<void> _openEditProfile() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.editProfile,
      arguments: _profile,
    );

    // Cek mounted dan tipe result
    if (!mounted || result is! Profile) return;

    setState(() => _profile = result);

    // Challenge ⭐⭐ Pertemuan 1: Tampilkan SnackBar feedback
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil diperbarui'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
  }

  /// Navigasi ke Halaman Pengaturan (Challenge ⭐ Pertemuan 2)
  Future<void> _openSettings() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.settings,
      arguments: _showBio,
    );

    if (!mounted || result is! bool) return;
    setState(() => _showBio = result);
  }

  /// Navigasi Logout dengan konfirmasi dialog (Lab 6 & Bonus Challenge Pertemuan 2)
  Future<void> _logout() async {
    // 🌟 Bonus: Konfirmasi dialog sebelum logout
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text(
          'Apakah kamu yakin ingin keluar dari aplikasi? '
          'Seluruh tumpukan halaman akan dibersihkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    // pushNamedAndRemoveUntil: Pindah ke Splash dan hapus semua halaman di stack (Lab 6)
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.splash,
      (route) => false,
    );
  }

  /// Tombol pengujian halaman 404 (Lab 6)
  void _testNotFoundRoute() {
    Navigator.pushNamed(context, '/halaman-ngawur');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kartu Profil Digital'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Pengaturan',
            onPressed: _openSettings,
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit profil',
            onPressed: _openEditProfile,
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Keluar',
            onPressed: _logout,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Foto Profil
          Center(
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 48,
                backgroundImage: const NetworkImage(
                  'https://picsum.photos/seed/profile/300/300',
                ),
                onBackgroundImageError: (exception, stackTrace) {},
                child: const Icon(Icons.person, size: 48),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Nama
          Text(
            _profile.name,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),

          // Jabatan (Challenge ⭐ Pertemuan 1)
          Center(
            child: Chip(
              avatar: const Icon(Icons.work_outline, size: 16),
              label: Text(_profile.role),
              backgroundColor: theme.colorScheme.primaryContainer,
              labelStyle: TextStyle(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
              ),
              side: BorderSide.none,
            ),
          ),
          const SizedBox(height: 8),

          // Bio (Bisa disembunyikan lewat pengaturan - Challenge ⭐ Pertemuan 2)
          if (_showBio) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _profile.bio,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),

          // Daftar Proyek
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daftar Proyek',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${dummyProjects.length} Proyek',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          for (final project in dummyProjects)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                // Hero Animation pada ikon proyek (🌟 Bonus Challenge Pertemuan 1)
                leading: Hero(
                  tag: 'project-icon-${project.id}',
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.folder_open_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                title: Text(
                  project.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  project.techStack.join(' • '),
                  style: TextStyle(color: Colors.grey[600]),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _openProjectDetail(project),
              ),
            ),

          const SizedBox(height: 20),

          // Tombol Uji Halaman 404 (Lab 6)
          Center(
            child: TextButton.icon(
              onPressed: _testNotFoundRoute,
              icon: const Icon(Icons.bug_report_outlined, size: 18),
              label: const Text('Uji Navigasi Route 404'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
