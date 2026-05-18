class AuthTokenEntity {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  const AuthTokenEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
