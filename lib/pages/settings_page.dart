import 'package:flutter/material.dart';

/// Halaman Pengaturan (Challenge ⭐ Pertemuan 2)
class SettingsPage extends StatefulWidget {
  final bool initialShowBio;

  const SettingsPage({
    super.key,
    this.initialShowBio = true,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _showBio;
  bool _enableNotifications = true;

  @override
  void initState() {
    super.initState();
    _showBio = widget.initialShowBio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, _showBio),
        ),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.visibility_outlined),
            title: const Text('Tampilkan Bio'),
            subtitle: const Text('Tampilkan atau sembunyikan bio pada profil'),
            value: _showBio,
            onChanged: (val) {
              setState(() => _showBio = val);
            },
          ),
          const Divider(),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Notifikasi Aktivitas'),
            subtitle: const Text('Terima pembaruan dan informasi proyek'),
            value: _enableNotifications,
            onChanged: (val) {
              setState(() => _enableNotifications = val);
            },
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Versi Aplikasi'),
            subtitle: Text('Kartu Profil Digital v1.0.0 (Modul 8)'),
          ),
        ],
      ),
    );
  }
}
