class LoginRequestDto {
  final String phoneNumber;
  final String password;

  const LoginRequestDto({required this.phoneNumber, required this.password});

  Map<String, dynamic> toJson() {
    return {'phoneNumber': phoneNumber, 'password': password};
  }
}
