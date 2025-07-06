import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String role;
  final String about;
  final List<String> dietaryRestrictions;
  final String location;
  final ProfileStats stats;

  const ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.role,
    required this.about,
    required this.dietaryRestrictions,
    required this.location,
    required this.stats,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      role: json['role'] as String,
      about: json['about'] as String,
      dietaryRestrictions: List<String>.from(
        json['dietaryRestrictions'] as List,
      ),
      location: json['location'] as String,
      stats: ProfileStats.fromJson(json['stats'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'role': role,
      'about': about,
      'dietaryRestrictions': dietaryRestrictions,
      'location': location,
      'stats': stats.toJson(),
    };
  }

  ProfileModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? role,
    String? about,
    List<String>? dietaryRestrictions,
    String? location,
    ProfileStats? stats,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      about: about ?? this.about,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      location: location ?? this.location,
      stats: stats ?? this.stats,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    avatarUrl,
    role,
    about,
    dietaryRestrictions,
    location,
    stats,
  ];

  // Mock data para desarrollo
  static ProfileModel get mockProfile => ProfileModel(
    id: '1',
    name: 'John Doe',
    email: 'john.doe@konecta.com',
    avatarUrl: null,
    role: 'Participant',
    about:
        'Digital Marketing Specialist passionate about innovation and technology. Excited to connect with fellow professionals at Convention 2024!',
    dietaryRestrictions: ['Vegetarian', 'No nuts'],
    location: 'Lima, Peru',
    stats: const ProfileStats(posts: 12, following: 45, followers: 38),
  );
}

class ProfileStats extends Equatable {
  final int posts;
  final int following;
  final int followers;

  const ProfileStats({
    required this.posts,
    required this.following,
    required this.followers,
  });

  factory ProfileStats.fromJson(Map<String, dynamic> json) {
    return ProfileStats(
      posts: json['posts'] as int,
      following: json['following'] as int,
      followers: json['followers'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'posts': posts, 'following': following, 'followers': followers};
  }

  ProfileStats copyWith({int? posts, int? following, int? followers}) {
    return ProfileStats(
      posts: posts ?? this.posts,
      following: following ?? this.following,
      followers: followers ?? this.followers,
    );
  }

  @override
  List<Object> get props => [posts, following, followers];
}
