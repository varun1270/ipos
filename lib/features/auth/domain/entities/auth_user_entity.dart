class AuthUserEntity {
  final String id;
  final String name;
  final String phoneNumber;
  final String? email;

  const AuthUserEntity({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.email,
  });
}
