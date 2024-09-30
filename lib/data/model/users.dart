class Users {
  final String name;
  final String email;
  final String password;
  final String? userId;

  Users({
    required this.name,
    required this.email,
    required this.password,
    this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      name: json['name'],
      email: json['email'],
      password: '',
      userId: json['userId'],
    );
  }
}
