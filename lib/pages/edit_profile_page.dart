import 'package:flutter/material.dart';
import '../models/models.dart';

class EditProfilePage extends StatefulWidget {
  final Profile profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _roleController;
  late final TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    // Isi awal form diambil dari profile yang dikirim lewat constructor
    _nameController = TextEditingController(text: widget.profile.name);
    _roleController = TextEditingController(text: widget.profile.role);
    _bioController = TextEditingController(text: widget.profile.bio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  /// Cek apakah pengguna telah mengubah salah satu isi form
  bool get _hasChanges {
    return _nameController.text.trim() != widget.profile.name ||
        _roleController.text.trim() != widget.profile.role ||
        _bioController.text.trim() != widget.profile.bio;
  }

  /// Dialog konfirmasi buang perubahan (Challenge ⭐⭐⭐ Pertemuan 1)
  Future<bool> _showDiscardDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Buang perubahan?'),
        content: const Text(
          'Perubahan yang kamu buat belum disimpan. '
          'Apakah kamu yakin ingin keluar dan membuang perubahan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: const Text('Buang'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _handleCancel() async {
    if (_hasChanges) {
      final discard = await _showDiscardDialog();
      if (discard && mounted) {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final updated = widget.profile.copyWith(
      name: _nameController.text.trim(),
      role: _roleController.text.trim(),
      bio: _bioController.text.trim(),
    );

    // Tutup halaman SEKALIGUS kirim hasil ke halaman sebelumnya (Lab 3)
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    // Challenge ⭐⭐⭐ Pertemuan 1: PopScope untuk mencegah pop sebelum konfirmasi
    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final discard = await _showDiscardDialog();
        if (discard && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profil'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            onChanged: () => setState(() {}), // refresh status dirty
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Nama tidak boleh kosong'
                      : null,
                ),
                const SizedBox(height: 16),
                // Challenge ⭐ Pertemuan 1: field jabatan
                TextFormField(
                  controller: _roleController,
                  decoration: const InputDecoration(
                    labelText: 'Jabatan / Profesi',
                    prefixIcon: Icon(Icons.work_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Jabatan tidak boleh kosong'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bioController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Bio Singkat',
                    alignLabelWithHint: true,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 56),
                      child: Icon(Icons.description_outlined),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _handleCancel,
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _save,
                        child: const Text('Simpan'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
