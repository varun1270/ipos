class OtpVerifyRequestDto {
  final String phoneNumber;
  final String otp;

  const OtpVerifyRequestDto({required this.phoneNumber, required this.otp});

  Map<String, dynamic> toJson() {
    return {'phoneNumber': phoneNumber, 'otp': otp};
  }
}
