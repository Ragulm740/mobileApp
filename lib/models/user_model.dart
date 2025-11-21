class User {
  final String name;
  final String mobile;
  final bool isLoggedIn;

  User({
    required this.name,
    required this.mobile,
    this.isLoggedIn = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      isLoggedIn: json['isLoggedIn'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mobile': mobile,
      'isLoggedIn': isLoggedIn,
    };
  }
}