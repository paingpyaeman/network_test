class User {
  final int id;
  final String token;
  final String username;
  final String email;
  final String fullName;

  User({
    required this.id,
    required this.token,
    required this.username,
    required this.email,
    required this.fullName,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    token: json['token'],
    username: json['username'],
    email: json['email'],
    fullName: json['fullName'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'token': token,
    'username': username,
    'email': email,
    'fullName': fullName,
  };
}
