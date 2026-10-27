import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartprofile/main.dart';

void main() {
  testWidgets('Alur navigasi lengkap: Splash -> Profile -> Detail -> Edit -> Settings -> 404 -> Logout',
      (WidgetTester tester) async {
    // 1. Build app (Mulai di SplashPage)
    await tester.pumpWidget(const MyApp());
    expect(find.text('Kartu Profil Digital'), findsOneWidget);

    // Majukan waktu 2 detik agar timer splash selesai dan pindah ke ProfilePage
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Verifikasi berada di Halaman Profil
    expect(find.text('Daftar Proyek'), findsOneWidget);
    expect(find.text('Muhammad Fahmi'), findsOneWidget);
    expect(find.text('Software Engineer & Mobile Developer'), findsOneWidget);

    // 2. Buka Detail Proyek (Lab 2, 5 & Challenge ⭐⭐ Pertemuan 2 - passing ID)
    await tester.tap(find.text('Aplikasi Absensi Kampus'));
    await tester.pumpAndSettle();

    // Verifikasi berada di Halaman Detail Proyek
    expect(find.text('Deskripsi Proyek'), findsOneWidget);
    expect(find.text('Teknologi yang Digunakan'), findsOneWidget);

    // Kembali ke Profil
    await tester.tap(find.text('Kembali ke Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Daftar Proyek'), findsOneWidget);

    // 3. Buka Edit Profil (Lab 3, 5 & Challenge ⭐ Pertemuan 1 - field jabatan)
    await tester.tap(find.byTooltip('Edit profil'));
    await tester.pumpAndSettle();
    expect(find.text('Edit Profil'), findsOneWidget);

    // Edit nama dan simpan
    await tester.enterText(find.widgetWithText(TextFormField, 'Muhammad Fahmi'), 'Fahmi Updated');
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    // Verifikasi hasil tersimpan di Profil dan SnackBar muncul (Challenge ⭐⭐ Pertemuan 1)
    expect(find.text('Fahmi Updated'), findsOneWidget);
    expect(find.text('Profil berhasil diperbarui'), findsOneWidget);

    // 4. Buka Pengaturan (Challenge ⭐ Pertemuan 2)
    await tester.tap(find.byTooltip('Pengaturan'));
    await tester.pumpAndSettle();
    expect(find.text('Pengaturan'), findsOneWidget);
    expect(find.text('Tampilkan Bio'), findsOneWidget);

    // Kembali dari pengaturan
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // 5. Uji Navigasi Route 404 (Lab 6 & 8)
    // Tunggu SnackBar selesai agar tidak menghalangi hit-test
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Uji Navigasi Route 404'));
    await tester.pumpAndSettle();

    expect(find.text('Halaman Tidak Ditemukan (404)'), findsOneWidget);
    await tester.tap(find.text('Ke Beranda'));
    await tester.pumpAndSettle();
    expect(find.text('Daftar Proyek'), findsOneWidget);

    // 6. Logout dengan konfirmasi (Lab 6 & Bonus Challenge Pertemuan 2)
    await tester.tap(find.byTooltip('Keluar'));
    await tester.pumpAndSettle();
    expect(find.text('Konfirmasi Keluar'), findsOneWidget);

    // Tekan 'Keluar' pada dialog konfirmasi
    await tester.tap(find.text('Keluar'));
    await tester.pump(); // memulai pop dialog
    await tester.pump(const Duration(milliseconds: 300)); // dialog selesai ditutup
    await tester.pump(const Duration(milliseconds: 300)); // transisi ke Splash selesai
    expect(find.text('Praktikum Pemrograman Mobile'), findsOneWidget);

    // Majukan sisa waktu Splash (2 detik): Splash otomatis beralih ke Profile dan stack bersih
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Daftar Proyek'), findsOneWidget);
  });

  testWidgets('Challenge ⭐⭐⭐: PopScope konfirmasi buang perubahan pada form edit',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Buka Edit Profil
    await tester.tap(find.byTooltip('Edit profil'));
    await tester.pumpAndSettle();

    // Ubah nama
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Muhammad Fahmi'), 'Perubahan Baru');
    await tester.pumpAndSettle();

    // Tekan Batal
    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();

    // Muncul dialog "Buang perubahan?"
    expect(find.text('Buang perubahan?'), findsOneWidget);

    // Jika pilih 'Batal' di dialog -> tetap di halaman Edit
    await tester.tap(find.widgetWithText(TextButton, 'Batal'));
    await tester.pumpAndSettle();
    expect(find.text('Edit Profil'), findsOneWidget);

    // Tekan Batal lagi, lalu pilih 'Buang'
    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Buang'));
    await tester.pumpAndSettle();

    // Kembali ke Profil dan nama TIDAK berubah
    expect(find.text('Daftar Proyek'), findsOneWidget);
    expect(find.text('Muhammad Fahmi'), findsOneWidget);
  });
}
