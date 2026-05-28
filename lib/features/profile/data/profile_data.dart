import 'package:flutter/material.dart';

import 'models/profile_model.dart';

const profilePages = [
  // =========================
  // USER PROFILE
  // =========================
  ProfileModel(
    name: 'John Doe',
    email: 'john.doe@example.com',
    profilePictureUrl: 'https://i.pravatar.cc/300?img=12',
    bio: 'Flutter developer passionate about building clean and scalable mobile apps.',
    location: 'Jaipur, Rajasthan',
    phoneNumber: '+91 9876543210',
    websiteUrl: 'https://johndoe.dev',

    // Light Theme Colors
    backgroundColorLight: Color(0xFFF5F7FA),
    textColorLight: Color(0xFF1A1A1A),

    // Dark Theme Colors
    backgroundColorDark: Color(0xFF1E1E1E),
    textColorDark: Color(0xFFFFFFFF),
  ),
];
