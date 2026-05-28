import 'package:flutter/material.dart';

class ProfileModel {
  /// User's full name
  final String name;

  /// User's email address
  final String email;

  /// User's profile picture URL (optional)
  final String? profilePictureUrl;

  /// User's bio or description (optional)
  final String? bio;

  /// User's location (optional)
  final String? location;

  /// User's phone number (optional)
  final String? phoneNumber;

  /// User's website URL (optional)
  final String? websiteUrl;

  /// Custom colors for the profile card (optional override)
  final Color? backgroundColorLight;
  final Color? backgroundColorDark;
  final Color? textColorLight;
  final Color? textColorDark;

  const ProfileModel({
    required this.name,
    required this.email,
    this.profilePictureUrl,
    this.bio,
    this.location,
    this.phoneNumber,
    this.websiteUrl,
    this.backgroundColorLight,
    this.backgroundColorDark,
    this.textColorLight,
    this.textColorDark,
  });
}
