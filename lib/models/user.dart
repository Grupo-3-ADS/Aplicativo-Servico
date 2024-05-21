enum UserType { client, provider }

class User {
  final String id;
  final String name;
  final UserType userType;

  User({required this.id, required this.name, required this.userType});
}
