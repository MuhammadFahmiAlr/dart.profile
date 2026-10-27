import '../models/models.dart';

const defaultProfile = Profile(
  name: 'Muhammad Fahmi',
  role: 'Software Engineer & Mobile Developer',
  bio: 'Mahasiswa Teknik Informatika yang sedang belajar Flutter. '
      'Suka membangun aplikasi mobile yang rapi, modular, dan bermanfaat.',
);

const dummyProjects = <Project>[
  Project(
    id: 'p1',
    title: 'Aplikasi Absensi Kampus',
    description: 'Aplikasi presensi mahasiswa berbasis QR code dengan '
        'rekap kehadiran otomatis per mata kuliah.',
    techStack: ['Flutter', 'Firebase', 'Provider'],
  ),
  Project(
    id: 'p2',
    title: 'Katalog UMKM Jember',
    description: 'Katalog digital untuk membantu UMKM lokal memasarkan '
        'produknya secara online.',
    techStack: ['Flutter', 'REST API', 'Dio'],
  ),
  Project(
    id: 'p3',
    title: 'Monitoring Kandang Pintar',
    description: 'Dashboard mobile untuk memantau suhu dan kelembapan '
        'kandang secara real-time.',
    techStack: ['Flutter', 'MQTT', 'Cloud'],
  ),
];

/// Helper pencari proyek berdasarkan ID (Lab 8 & Challenge ⭐⭐ Pertemuan 2)
Project? findProjectById(String id) {
  for (final project in dummyProjects) {
    if (project.id == id) return project;
  }
  return null;
}
