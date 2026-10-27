class Project {
  final String id;
  final String title;
  final String description;
  final List<String> techStack;

  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.techStack,
  });
}

class Profile {
  final String name;
  final String role; // Challenge ⭐ Pertemuan 1: field jabatan
  final String bio;

  const Profile({
    required this.name,
    required this.role,
    required this.bio,
  });

  /// Membuat salinan Profile dengan sebagian field diganti.
  Profile copyWith({
    String? name,
    String? role,
    String? bio,
  }) {
    return Profile(
      name: name ?? this.name,
      role: role ?? this.role,
      bio: bio ?? this.bio,
    );
  }
}
