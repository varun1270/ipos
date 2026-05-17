# IPOS Project Structure Guide

This document explains how the project is organized right now, where key pieces belong (login, routing, API), and how to create new pages/features consistently.

## 1) Tech Stack and Architecture

- Framework: Flutter (Dart SDK ^3.10.1)
- State management: Riverpod (manual providers; generator currently disabled)
- Routing: GoRouter
- Theming: central app theme in core
- Pattern: Feature-first structure with Clean Architecture style subfolders

High-level idea:

- Shared infrastructure goes in lib/core
- Domain-specific code goes in lib/features/<feature_name>
- Cross-feature reusable models/providers/widgets go in lib/shared
- Local database-related scaffolding goes in lib/database

## 2) Current Top-Level Source Layout (lib)

```text
lib/
  main.dart
  bootstrap.dart
  core/
    config/
    constants/
    extensions/
    localization/
    network/
    offline/
    router/
      router_provider.dart
    services/
    theme/
      app_colors.dart
      app_theme.dart
    utils/
      animation_utils.dart
    widgets/
  database/
    dao/
    drift/
    migrations/
    tables/
  features/
    auth/
      data/
      domain/
      presentation/
      routes/
    ... many planned feature folders ...
    onboarding/
      presentation/screens/onboarding_screen.dart
    splash/
      presentation/screens/splash_screen.dart
  l10n/
    en.json
    gu.json
    hi.json
  shared/
    enums/
    mixins/
    models/
    providers/
    repositories/
    widgets/
```

## 3) Startup and App Entry Flow

### main.dart

- Application starts in main.dart.
- App is wrapped in ProviderScope (Riverpod root).
- MaterialApp.router is used.
- Router comes from core/router/router_provider.dart.
- Theme comes from core/theme/app_theme.dart.

### bootstrap.dart

- Exists as startup hook placeholder.
- Currently empty (no initialization logic yet).

Recommended future use for bootstrap:

- Firebase initialization
- Local DB setup
- Secure storage/session restore
- Dependency registration

## 4) Routing: Where Navigation Is Defined

Primary router file:

- lib/core/router/router_provider.dart

Current routes defined:

- /splash (name: splash)
- /login (name: login)

Important current status:

- Splash screen calls context.goNamed('onboarding').
- No onboarding route is currently registered in router_provider.dart.
- Router imports a LoginScreen file from features/login/presentation/screens/login_screen.dart, but that file does not exist in current source.

So today:

- Splash -> onboarding navigation target exists as a screen file, but route is missing.
- Login route exists, but referenced screen implementation is missing.

## 5) Login/Auth: Where It Should Be and What Exists

Auth feature scaffold exists at:

- lib/features/auth/

Subfolders already prepared:

- data/datasource, dto, models, repositories
- domain/entities, repositories, usecases
- presentation/controllers, providers, screens, widgets
- routes/

Current implementation status:

- Auth folders are mostly scaffold-only (no concrete auth screen files yet).
- Router currently references a different path: features/login/... (feature folder login does not exist).

Recommended convention (pick one and keep it consistent):

- Option A (preferred): use features/auth for login/register/otp screens.
- Option B: create a separate features/login feature and keep router import as-is.

## 6) API Layer: Where APIs Are Defined

Current status:

- No active API client implementation yet.
- lib/core/network is currently empty.
- In pubspec.yaml, network dependencies (dio, connectivity, etc.) are commented out.

Recommended API placement:

- Base HTTP setup: lib/core/network/
  - api_client.dart (Dio/HTTP client)
  - api_endpoints.dart (constants)
  - interceptors/ (auth header, logging, retry)
- Feature-level remote calls: lib/features/<feature>/data/datasource/
  - auth_remote_datasource.dart
  - product_remote_datasource.dart
- Feature repositories:
  - interface in domain/repositories/
  - implementation in data/repositories/

Data flow guideline:

- UI (presentation) -> usecase (domain) -> repository (domain contract) -> datasource (data)

## 7) Theme and Design System

Theme files:

- lib/core/theme/app_colors.dart
- lib/core/theme/app_theme.dart

What is centralized already:

- Color palette (indigo primary scale + semantic colors)
- Input/button/app bar defaults
- Text theme via Google Fonts Inter

Rule of thumb:

- Do not hardcode colors/styles in feature screens when a shared token exists.
- Add new reusable style tokens in core/theme.

## 8) Localization and Assets

Localization files:

- lib/l10n/en.json
- lib/l10n/gu.json
- lib/l10n/hi.json

Assets registered in pubspec.yaml:

- assets/logos/
- assets/icons/
- assets/images/
- assets/illustrations/
- assets/animations/
- assets/lottie/
- assets/mock/
- assets/translations/

Fonts:

- Inter family configured in pubspec.yaml.

## 9) How to Create a New Page (Recommended Process)

Example: create a Sales Report screen under reports feature.

1. Create screen file

- Path: lib/features/reports/presentation/screens/sales_report_screen.dart

2. Create any feature widgets

- Path: lib/features/reports/presentation/widgets/

3. Add provider/controller if state is needed

- Path: lib/features/reports/presentation/providers/ or controllers/

4. Register route in router_provider.dart

- Add GoRoute with path, name, and pageBuilder.

5. Navigate using named routes

- Use context.goNamed('salesReport') or context.pushNamed('salesReport').

6. If data is from server

- Add datasource + repository + usecase under reports/data and reports/domain.

7. If data is offline/local

- Add table/dao/migration under lib/database and repository mapping in feature layer.

8. Add tests (when test infra is added)

- widget test for screen
- unit test for usecase/repository

## 10) Route Naming and File Naming Conventions

Suggested conventions:

- Screen: snake_case + \_screen.dart
  - example: login_screen.dart
- Widgets: snake_case + \_widget.dart
- Provider files: <feature>\_provider.dart
- Route names: lowerCamelCase
  - example: login, onboarding, salesReport
- Feature route constants (optional):
  - keep route names/paths in a dedicated file inside feature/routes/

## 11) Known Gaps to Fix Next (High Priority)

1. Fix router/screen mismatch

- Either create lib/features/login/presentation/screens/login_screen.dart
- Or update router import and route to use auth feature path

2. Add onboarding route

- Add /onboarding route in router_provider.dart so splash navigation works.

3. Decide final auth feature naming

- Choose auth or login as feature namespace, then standardize imports.

4. Initialize API foundation

- Enable and configure network dependency (likely dio)
- Add base api_client.dart in core/network.

## 12) Quick Reference: Where Things Are

- App entry: lib/main.dart
- Startup hook: lib/bootstrap.dart
- Router: lib/core/router/router_provider.dart
- Theme/colors: lib/core/theme/
- Animation helpers: lib/core/utils/animation_utils.dart
- Splash screen: lib/features/splash/presentation/screens/splash_screen.dart
- Onboarding screen: lib/features/onboarding/presentation/screens/onboarding_screen.dart
- Auth feature scaffold: lib/features/auth/
- Shared reusable code: lib/shared/
- Database scaffold: lib/database/

---

If you follow this structure for each new feature, the project will stay scalable and easier to maintain as POS, CRM, and customer-app modules grow.
