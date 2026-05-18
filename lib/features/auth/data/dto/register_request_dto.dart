class RegisterRequestDto {
  final String name;
  final String phoneNumber;
  final String password;
  final String? email;

  const RegisterRequestDto({
    required this.name,
    required this.phoneNumber,
    required this.password,
    this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'password': password,
      if (email != null) 'email': email,
    };
  }
}
