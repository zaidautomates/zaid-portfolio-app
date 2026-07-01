class UserModel {
  final String id;
  final String name;
  final String email;
  final String about;
  final String role;
  final String tagline;
  final String profileImage;
  final String education;
  final String careerGoals;
  final String interests;
  final String location;
  final String phone;
  final String linkedin;
  final String github;
  final String website;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.about,
    required this.role,
    required this.tagline,
    required this.profileImage,
    required this.education,
    required this.careerGoals,
    required this.interests,
    required this.location,
    required this.phone,
    required this.linkedin,
    required this.github,
    required this.website,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      about: json['about'] ?? '',
      role: json['role'] ?? '',
      tagline: json['tagline'] ?? '',
      profileImage: json['profileImage'] ?? '',
      education: json['education'] ?? '',
      careerGoals: json['careerGoals'] ?? '',
      interests: json['interests'] ?? '',
      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
      linkedin: json['linkedin'] ?? '',
      github: json['github'] ?? '',
      website: json['website'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'about': about,
      'role': role,
      'tagline': tagline,
      'profileImage': profileImage,
      'education': education,
      'careerGoals': careerGoals,
      'interests': interests,
      'location': location,
      'phone': phone,
      'linkedin': linkedin,
      'github': github,
      'website': website,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? about,
    String? role,
    String? tagline,
    String? profileImage,
    String? education,
    String? careerGoals,
    String? interests,
    String? location,
    String? phone,
    String? linkedin,
    String? github,
    String? website,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      about: about ?? this.about,
      role: role ?? this.role,
      tagline: tagline ?? this.tagline,
      profileImage: profileImage ?? this.profileImage,
      education: education ?? this.education,
      careerGoals: careerGoals ?? this.careerGoals,
      interests: interests ?? this.interests,
      location: location ?? this.location,
      phone: phone ?? this.phone,
      linkedin: linkedin ?? this.linkedin,
      github: github ?? this.github,
      website: website ?? this.website,
    );
  }
}
