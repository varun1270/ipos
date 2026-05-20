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
# iPOS — Project Directory Structure

> Flutter application (`name: ipos`, version `1.0.0+1`, Dart SDK `^3.8.1`)
>
> The codebase follows a feature-first layout combined with **Clean Architecture**
> layers inside each feature (`data` → `domain` → `presenter`) and uses the
> **BLoC** pattern for state management with **Injector** for dependency injection.

---

## 1. Top-Level Layout

```
ipos-block/
├── android/                    # Android native project (Gradle, manifests, Kotlin)
├── ios/                        # iOS native project (Xcode workspace, Podfile, Swift)
├── web/                        # Flutter web entry (index.html, manifest, icons)
├── windows/                    # Flutter desktop (Windows) runner
├── assets/                     # Bundled images / static assets (e.g. logo.png)
├── dependencies/               # Vendored / forked local packages
│   └── platform_device_id/     # Local package referenced via `path:` in pubspec
├── lib/                        # All Dart application code (see §2)
├── test/                       # Widget / unit tests
│   └── widget_test.dart
├── analysis_options.yaml       # Lint rules (extends flutter_lints)
├── pubspec.yaml                # Package manifest & dependencies
├── pubspec.lock                # Locked dependency versions
├── .metadata                   # Flutter tool metadata
├── .flutter-plugins-dependencies
├── .gitignore
└── README.md
```

---

## 2. `lib/` — Application Source

```
lib/
├── main.dart                   # App entry point + MaterialApp + MultiBlocProvider
├── di.dart                     # Dependency-injection registration (Injector)
│
├── api/                        # HTTP networking layer (Dio)
│   ├── api_constants.dart      # Base URLs + endpoint path constants
│   ├── api_response.dart       # Generic ApiResponse<T> wrapper (success/failure)
│   ├── api_service.dart        # Singleton Dio client + Dev/Prod environment switch
│   ├── environment.dart        # Environment abstraction (baseUrl, apiKey, type)
│   ├── interceptors.dart       # Dio request/response/error interceptors
│   └── network.dart            # Connectivity check + snackbar helper
│
├── models/                     # Shared cross-feature DTOs
│   ├── error_response.dart
│   └── generic_response.dart
│
├── hive_service/               # Hive (local NoSQL) helpers
│   ├── hive_box_keys.dart      # Box & key string constants
│   └── hive_cart_service.dart  # Save/retrieve cart-related maps
│
├── splash_screen/              # Feature: Splash
│   └── presenter/
│       └── screen/
│           ├── splash_screen.dart
│           └── splash_screen_m.dart   # Active splash widget used by main.dart
│
├── login_screens/              # Feature: Login (Clean Architecture)
│   ├── data/
│   │   └── model/
│   │       ├── login_model.dart            # Response model
│   │       └── login_request_model.dart    # Request DTO
│   ├── domain/
│   │   ├── provider/
│   │   │   └── login_provider.dart         # Dio call to /login endpoint
│   │   └── repository/
│   │       └── login_repository.dart       # Repository wrapping provider
│   └── presenter/
│       ├── bloc/
│       │   ├── login_bloc.dart             # Bloc<LoginEvent, LoginState>
│       │   ├── login_event.dart            # part-of login_bloc.dart
│       │   └── login_state.dart            # part-of login_bloc.dart
│       └── screen/
│           └── login_screen.dart           # Login UI
│
├── logout/                     # Feature: Logout (Clean Architecture)
│   ├── model/
│   │   ├── logout_request_model.dart
│   │   └── logout_response_model.dart
│   ├── domain/
│   │   ├── logout_provider.dart
│   │   └── logout_repository.dart
│   └── bloc/
│       ├── logout_bloc.dart
│       ├── logout_event.dart
│       └── logout_state.dart
│
└── utils/                      # Cross-cutting utilities
    ├── app_constants.dart      # Misc app-wide constants
    ├── navigation_servie.dart  # Global NavigatorState key (NavigationService)
    │
    ├── constants/              # Static design / config constants
    │   ├── app_assets.dart     # Asset path strings
    │   ├── app_theme.dart      # Colors, theme tokens
    │   ├── regex_const.dart    # Validation regexes
    │   ├── routes.dart         # Named route name constants
    │   └── strings.dart        # Static strings (appName, etc.)
    │
    ├── shared/                 # Shared design primitives
    │   ├── colors.dart
    │   └── text_styles.dart
    │
    ├── hive/
    │   └── hive_register_adapter.dart   # Registers Hive type adapters + opens boxes
    │
    └── common_widgets/         # Reusable UI widgets
        ├── common.dart                  # vSpace/hSpace + tiny helpers
        ├── styles.dart                  # TextStyle helpers
        ├── shared_pref.dart             # SharedPreferences wrapper
        ├── text_widget.dart
        ├── input_field.dart
        ├── center_text_divider.dart
        ├── generic_bottomsheet.dart
        ├── message_box_widget.dart
        ├── buttons/
        │   ├── add_item_button.dart
        │   ├── add_time_delay_button.dart
        │   ├── filled_button_widget.dart
        │   ├── filledbox_button_widget.dart
        │   ├── outline_button_widget.dart
        │   ├── outlinebox_button_widget.dart
        │   ├── radio_button_widget.dart
        │   ├── multi_select_radio_button.dart
        │   └── social_login_button_widget.dart
        └── textfields/
            ├── textfield_widget.dart
            ├── label_textfield_widget.dart
            ├── label_textfield_row_widget.dart
            ├── label_password_textfield.dart
            └── label_password_textfield_widget.dart
```

---

## 3. Architecture Overview

The project applies **Clean Architecture per feature**. Each feature folder
(e.g. `login_screens/`, `logout/`) is split into three layers:

| Layer       | Folder       | Responsibility                                                |
| ----------- | ------------ | ------------------------------------------------------------- |
| Data        | `data/model` | Request/response DTOs, JSON (de)serialization                 |
| Domain      | `domain/`    | `provider/` performs the raw API call; `repository/` exposes business-friendly APIs to the Bloc |
| Presenter   | `presenter/` | `bloc/` holds UI state (Bloc / Events / States); `screen/` renders widgets that consume Bloc state |

### Data flow for a typical action

```
UI (screen)
   │ dispatches event
   ▼
Bloc  ──(Injector.get<Repository>())──▶  Repository
                                            │
                                            ▼
                                         Provider ──(ApiService.dio)──▶  Backend
                                            │
                                            ▼
                                       ApiResponse<T>
   ▲                                        │
   └──────────── State emitted ◀────────────┘
```

### Dependency Injection — `lib/di.dart`

Uses [`injector`](https://pub.dev/packages/injector) (with `injectable` /
`get_it` also present in `pubspec.yaml`). Registrations happen in
`setupDependencyInjections()` which is called from `main()`:

```dart
Injector injector = Injector.appInstance;
injector.registerSingleton<ApiService>(() => ApiService());
injector.registerDependency<LoginRepository>(() => LoginRepository());
injector.registerDependency<LoginProvider>(() => LoginProvider(api: injector.get<ApiService>()));
```

### Networking — `lib/api/`

- `ApiService` is a singleton factory exposing a configured `Dio` instance.
- It supports two environments (`_Dev`, `_Prod`) selected via `EnvironmentType`.
- `interceptors.dart` injects auth headers / logging into every request.
- `ApiResponse` wraps both success (`Response`) and failure (`DioException`) results.

### Local Storage

- **Hive** — opened in `main.dart` via `Hive.initFlutter()` then
  `HiveRegisterAdapter.registerAdapters()` + `openBox()` (see
  `lib/utils/hive/hive_register_adapter.dart`). Feature-specific helpers live in
  `lib/hive_service/`.
- **SharedPreferences** — wrapped by `lib/utils/common_widgets/shared_pref.dart`
  (e.g. stores `vendorColorTheme`).

### State Management

- `flutter_bloc` (^8.1.1) — one Bloc per feature, registered globally via
  `MultiBlocProvider` in `MyApp.build` (currently `LoginBloc`).
- Events/states are declared as `part`-files of their Bloc for cohesion.

### Navigation

- Centralised through `NavigationService.navigatorKey` (a global
  `GlobalKey<NavigatorState>`).
- Named routes are defined as constants in `lib/utils/constants/routes.dart`
  and registered in `MaterialApp.routes`. Initial route is
  `Routes.splashRoute` → after 3 s the splash screen pushes
  `Routes.loginRoute`.

---

## 4. App Bootstrap (`main.dart`)

1. `WidgetsFlutterBinding.ensureInitialized()`
2. `setupDependencyInjections()` — register singletons & dependencies
3. `configLoading()` — configure `flutter_easyloading` UI
4. `Hive.initFlutter()` → register adapters → open boxes
5. `SharedPref.load()` — preload preferences
6. `runApp(MyApp(...))` — wraps the app in `MultiBlocProvider` and
   `MaterialApp` with the named-routes table.

---

## 5. Notable Third-Party Integrations (from `pubspec.yaml`)

| Concern             | Packages                                                                |
| ------------------- | ----------------------------------------------------------------------- |
| State Management    | `flutter_bloc`, `bloc`, `equatable`                                     |
| DI                  | `injector`, `injectable`, `get_it`                                      |
| Networking          | `dio`, `http`, `connectivity_plus`                                      |
| Local Storage       | `hive`, `hive_flutter`, `shared_preferences`, `path_provider`           |
| Auth / Social Login | `firebase_auth`, `google_sign_in`, `flutter_facebook_auth`, `sign_in_with_apple` |
| Firebase            | `firebase_core`, `firebase_messaging`, `firebase_crashlytics`, `firebase_remote_config` |
| Payments            | `flutter_stripe`, `pay`                                                 |
| Realtime / Chat     | `pubnub`                                                                |
| KYC                 | `veriff_flutter`                                                        |
| Location / Maps     | `geolocator`, `geocoding`, `flutter_google_places`                      |
| UI / UX             | `flutter_easyloading`, `fluttertoast`, `cached_network_image`, `flutter_svg`, `loading_animation_widget`, `pull_to_refresh`, `infinite_scroll_pagination`, `auto_size_text`, `flutter_html`, `flutter_widget_from_html`, `pinch_zoom`, `country_picker`, `bubble`, `grouped_list`, `flutter_rating_bar`, `otp_pin_field` |
| PDFs / Files        | `syncfusion_flutter_pdf`, `open_file`, `image_picker`                   |
| Notifications       | `flutter_local_notifications`, `firebase_messaging`                     |
| Misc                | `permission_handler`, `url_launcher`, `crypto`, `intl`, `collection`, `flutter_phone_direct_caller`, `flutter_multi_formatter`, `flutter_typeahead`, `device_info_plus`, `platform_device_id` (local) |

Dev dependencies: `flutter_test`, `hive_generator`, `flutter_lints`.

---

## 6. Assets & Vendored Packages

- **`assets/`** — currently contains `logo.png`. Registered in `pubspec.yaml`
  via `assets: - assets/`. The splash screen renders this image.
- **`dependencies/platform_device_id/`** — a locally-vendored copy of the
  `platform_device_id` plugin referenced through a `path:` dependency. Useful
  for patching the upstream plugin without forking on pub.dev.

---

## 7. Tests

`test/widget_test.dart` is the default Flutter starter test. There is currently
no broader test coverage; new tests would mirror the feature layout under
`test/<feature>/...`.

---

## 8. Conventions & Tips for Adding New Features

When adding a new feature (e.g. `employees/`), mirror the existing pattern:

```
lib/employees/
├── data/
│   └── model/
│       ├── employee_model.dart
│       └── employee_request_model.dart
├── domain/
│   ├── provider/employee_provider.dart      # Dio call
│   └── repository/employee_repository.dart  # Business API
└── presenter/
    ├── bloc/
    │   ├── employee_bloc.dart
    │   ├── employee_event.dart   # part of employee_bloc.dart
    │   └── employee_state.dart   # part of employee_bloc.dart
    └── screen/employee_screen.dart
```

Then:

1. Add API endpoint(s) to `lib/api/api_constants.dart`.
2. Register the new `Provider` and `Repository` in `lib/di.dart`.
3. Add the new route(s) in `lib/utils/constants/routes.dart` and wire them in
   `MaterialApp.routes` in `main.dart`.
4. Provide the new Bloc via `MultiBlocProvider` (or scoped `BlocProvider` on
   the screen itself).
5. Reuse widgets from `lib/utils/common_widgets/` and tokens from
   `lib/utils/constants/` / `lib/utils/shared/` for consistency.

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
