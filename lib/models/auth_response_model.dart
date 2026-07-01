class AuthResponseModel {
  final String token;
  final String userId;
  final String userName;
  final String userEmail;

  AuthResponseModel({
    required this.token,
    required this.userId,
    required this.userName,
    required this.userEmail,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] ?? {};
    return AuthResponseModel(
      token: json['token'] ?? '',
      userId: userJson['id'] ?? userJson['_id'] ?? '',
      userName: userJson['name'] ?? '',
      userEmail: userJson['email'] ?? '',
    );
  }
}
