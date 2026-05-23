import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// App-wide theme mode. Defaults to system (follows OS light/dark).
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);
