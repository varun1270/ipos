# IPOS — Directory Structure Reference

> A complete map of the `ipos` Flutter project. Use this as the canonical reference for "where does X live?" and "where should new code go?"
>
> **Project**: Offline-first POS + CRM + Customer Commerce App
> **Framework**: Flutter (Dart SDK ^3.10.1)
> **Architecture**: Feature-first + Clean Architecture (data / domain / presentation / routes)

---

## 1. Top-Level Layout

```text
ipos/
├── android/                  # Android native project (Gradle, manifest, icons)
├── ios/                      # iOS native project (Xcode workspace, Info.plist)
├── macos/                    # macOS desktop runner
├── linux/                    # Linux desktop runner
├── windows/                  # Windows desktop runner
├── web/                      # Web entry (index.html, manifest, icons)
│
├── assets/                   # All static assets bundled into the app
├── lib/                      # Dart application source (see §3)
├── doc/                      # Project documentation (this file lives here)
├── build/                    # Build outputs (gitignored)
│
├── .vscode/                  # Editor settings + launch.json
├── .idea/                    # IntelliJ / Android Studio settings
├── .github/                  # GitHub workflows / templates
│
├── analysis_options.yaml     # Dart analyzer + lint rules (flutter_lints)
├── pubspec.yaml              # Dependencies, assets, fonts, app metadata
├── pubspec.lock              # Locked dependency versions
└── README.md
```

---

## 2. `assets/` — Bundled Resources

Registered in `pubspec.yaml` under `flutter.assets`.

```text
assets/
├── animations/               # Custom motion assets
├── fonts/                    # Inter font family (Regular / Medium / SemiBold / Bold)
├── icons/                    # App-internal iconography
├── illustrations/            # Onboarding & empty-state illustrations
├── images/                   # Photographs / raster imagery
├── logos/                    # app_logo.png, splash_logo.png (launcher + splash)
├── lottie/                   # Lottie JSON animations
├── mock/                     # Mock JSON used for local development
└── translations/             # (reserved) — current strings live in lib/l10n
```

---

## 3. `lib/` — Application Source

```text
lib/
├── main.dart                 # App entry: ProviderScope + MaterialApp.router
├── bootstrap.dart            # Startup hook (Firebase, DB, secure storage, etc.)
│
├── core/                     # Cross-cutting infrastructure (see §4)
├── shared/                   # Cross-feature reusable building blocks (see §5)
├── database/                 # Offline DB scaffolding — Drift (see §6)
├── features/                 # All product features (see §7)
└── l10n/                     # Localization JSON (en / gu / hi)
```

### 3.1 Entry Point Flow

1. `main()` calls `WidgetsFlutterBinding.ensureInitialized()`.
2. `_enableHighRefreshRate()` opts in to high refresh on Android.
3. App is wrapped in `ProviderScope` (Riverpod root).
4. `MainApp` reads `routerProvider` and `themeProvider`, then mounts `MaterialApp.router`.
5. Router boots at `/splash` → `/onboarding` → `/login` (auth shell).

---

## 4. `lib/core/` — Cross-Cutting Infrastructure

Code that is **not tied to a single feature** and is consumed by many features.

```text
core/
├── config/                   # App-wide config (env, flavors) — reserved
├── constants/                # Hardcoded constants (keys, durations)  — reserved
├── extensions/               # Dart/Flutter extension methods         — reserved
├── localization/             # i18n loader / helpers                  — reserved
├── network/                  # HTTP client, interceptors, endpoints   — reserved
├── offline/                  # Sync engine / queue                     — reserved
├── router/
│   └── router_provider.dart  # GoRouter Riverpod provider, registers all routes
├── services/                 # Singleton services (analytics, prefs)  — reserved
├── theme/
│   ├── app_colors.dart       # AppColors palette (indigo + semantic tokens)
│   └── app_theme.dart        # ThemeData (light), text theme, component themes
├── utils/
│   ├── animation_utils.dart  # Reusable animation helpers
│   └── responsive_utils.dart # Breakpoint helpers
└── widgets/
    └── adaptive_content.dart # Adaptive (mobile/tablet/desktop) wrapper
```

**Rule of thumb**: If two or more features would import it, it belongs in `core/`.

---

## 5. `lib/shared/` — Reusable Building Blocks

Lighter weight than `core/`. Holds **domain-agnostic** reusable code that doesn't qualify as "infrastructure".

```text
shared/
├── enums/                    # App-wide enums
├── mixins/                   # Reusable mixins
├── models/                   # Generic models (e.g. PaginatedResponse<T>)
├── providers/                # Cross-feature Riverpod providers
├── repositories/             # Generic / cross-feature repository helpers
└── widgets/
    └── app_snackbar.dart     # Standardized snackbar API
```

---

## 6. `lib/database/` — Offline / Local Persistence

Reserved for Drift-based offline storage (dependencies currently commented out in `pubspec.yaml`).

```text
database/
├── dao/                      # Data Access Objects (per table)
├── drift/                    # Generated Drift code + DB definition
├── migrations/               # Schema migrations
└── tables/                   # Drift table definitions
```

---

## 7. `lib/features/` — Product Features

Every product capability is its own folder. Each feature follows the **same Clean Architecture layout** (see §8).

```text
features/
├── auth/                     # Login / Register / OTP            (implemented)
├── onboarding/               # First-run onboarding              (implemented)
├── splash/                   # Splash screen                     (implemented)
│
├── dashboard/                # Merchant dashboard                (scaffold)
├── pos/                      # Point-of-sale checkout flow       (scaffold)
├── products/                 # Product catalog                   (scaffold)
├── customers/                # CRM — customer records            (scaffold)
├── suppliers/                # Supplier / vendor management      (scaffold)
├── invoices/                 # Invoicing                         (scaffold)
├── receipt/                  # Receipt generation / printing     (scaffold)
├── purchases/                # Purchase orders                   (scaffold)
├── returns/                  # Returns & refunds                 (scaffold)
├── transfers/                # Stock transfers between stores    (scaffold)
├── expenses/                 # Expense tracking                  (scaffold)
├── credit/                   # Customer credit ledger            (scaffold)
├── delivery/                 # Delivery / dispatch               (scaffold)
├── reports/                  # Reports & analytics               (scaffold)
├── notifications/            # In-app notifications              (scaffold)
├── settings/                 # App + store settings              (scaffold)
├── security/                 # PIN / biometric / sessions        (scaffold)
├── store/                    # Store profile / multi-store       (scaffold)
│
└── customer_app/             # End-customer-facing module (sub-features below)
    ├── dashboard/
    ├── browse/
    ├── shop_selection/
    ├── loyalty/
    ├── wallet/
    ├── referrals/
    ├── tracking/
    └── analytics/
```

> `customer_app/` is special: it groups multiple sub-features that belong to the **customer-facing** half of the platform (vs. the merchant POS). Each sub-feature follows the same Clean Architecture layout.

### 7.1 Currently Implemented (has real Dart files)

| Feature | What exists |
| --- | --- |
| `splash` | `presentation/screens/splash_screen.dart` |
| `onboarding` | data, domain/models, presentation (screens, widgets, controller, animations), routes |
| `auth` | Full data / domain / presentation stack — login, register, OTP shell + widgets |

All other feature folders are **empty scaffolds** waiting to be filled in.

---

## 8. Per-Feature Layout (Clean Architecture)

Every feature uses this exact structure:

```text
features/<feature>/
├── data/                          # Outer layer — talks to the world
│   ├── datasource/                #   remote (HTTP) + local (DB) sources
│   ├── dto/                       #   request/response DTOs
│   ├── models/                    #   data-layer models (often with JSON ser.)
│   └── repositories/              #   repository implementations
│
├── domain/                        # Pure Dart — no Flutter imports
│   ├── entities/                  #   business entities (immutable)
│   ├── repositories/              #   repository interfaces (contracts)
│   └── usecases/                  #   single-purpose business operations
│
├── presentation/                  # UI layer
│   ├── animations/                #   feature-local animation helpers
│   ├── controllers/               #   Riverpod controllers (StateNotifier / Notifier)
│   ├── providers/                 #   Riverpod providers (DI for this feature)
│   ├── screens/                   #   full-page widgets (one per route)
│   └── widgets/                   #   smaller composable widgets for this feature
│
└── routes/                        # GoRoute definitions exported as a list/const
```

### 8.1 Data Flow

```
UI (screen / widget)
  → controller (presentation)
    → usecase (domain)
      → repository interface (domain)
        → repository impl (data)
          → datasource (data) → API / DB
```

UI must **never** import from `data/` directly. UI talks to `presentation/`, which talks to `domain/`.

---

## 9. Routing

All routes are registered through **one** Riverpod provider:

- `lib/core/router/router_provider.dart`

Feature route lists are **imported and spread** into the main router:

```dart
GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash',     name: 'splash',     ...),
    GoRoute(path: '/onboarding', name: 'onboarding', ...),
    ...authRoutes, // from features/auth/routes/auth_routes.dart
  ],
)
```

**Currently registered routes**:

| Path | Name | Screen |
| --- | --- | --- |
| `/splash` | `splash` | `SplashScreen` |
| `/onboarding` | `onboarding` | `OnboardingScreen` |
| `/login` | `login` | `AuthShellScreen(initialTab: 0)` |
| `/register` | `register` | `AuthShellScreen(initialTab: 1)` |
| `/otp` | `otp` | `OtpScreen` (reads `?phone=` query) |

**Convention**: each feature exposes a `List<RouteBase>` (or constants class) from `features/<feature>/routes/`. Add new routes by importing and spreading that list into `router_provider.dart`.

---

## 10. Theming

Centralized in `lib/core/theme/`:

- `app_colors.dart` — Indigo-based palette + semantic tokens (`success`, `warning`, `error`, `info`) + splash-specific tokens.
- `app_theme.dart` — Exposes `themeProvider`. Defines `lightTheme` (Material 3) with custom `appBarTheme`, button themes, `inputDecorationTheme`, and a full `TextTheme` using Google Fonts **Inter**.

**Rule**: never hardcode colors or font families inside feature screens. Use `AppColors.xxx` and `Theme.of(context).textTheme.xxx`.

---

## 11. Localization

- `lib/l10n/en.json` — English
- `lib/l10n/gu.json` — Gujarati
- `lib/l10n/hi.json` — Hindi

The actual i18n loader/provider lives under `lib/core/localization/` (currently reserved).

---

## 12. State Management & DI

- **Riverpod** (`flutter_riverpod ^2.6.1`) — manual providers (the code generator is intentionally disabled in `pubspec.yaml` until analyzer compatibility is resolved).
- Each feature owns its providers/controllers under `presentation/providers/` and `presentation/controllers/`.
- Cross-feature providers go in `lib/shared/providers/`.

---

## 13. Key Dependencies (active)

From `pubspec.yaml` — only **uncommented** dependencies are installed:

| Package | Purpose |
| --- | --- |
| `flutter_riverpod` | State management |
| `go_router` | Declarative routing |
| `google_fonts` | Inter font loading |
| `smooth_page_indicator` | Onboarding page indicator |
| `flutter_animate` | Declarative animations |
| `flutter_displaymode` | High refresh rate on Android |
| `flutter_lints` (dev) | Lint rules |
| `freezed` / `freezed_annotation` (dev) | Immutable models / unions |
| `json_serializable` / `json_annotation` (dev) | JSON codegen |
| `build_runner` (dev) | Code generation runner |
| `flutter_launcher_icons` (dev) | App icon generation |
| `flutter_native_splash` (dev) | Native splash generation |

Many other packages (Drift, Hive, Dio, Firebase, printing, scanning, etc.) are **commented out** as planned additions.

---

## 14. Adding a New Feature — Checklist

1. **Create folder**: `lib/features/<feature_name>/` with the full Clean Architecture skeleton (data, domain, presentation, routes).
2. **Domain first**: define entities + repository interface + usecases.
3. **Data layer**: DTOs, models, datasources, repository implementation.
4. **Presentation**: providers (DI) → controllers → screens → widgets.
5. **Routes**: export a `List<RouteBase>` from `routes/<feature>_routes.dart`.
6. **Register**: spread that list into `core/router/router_provider.dart`.
7. **Theme-driven UI**: only use `AppColors` + `Theme.of(context).textTheme`.
8. **Assets**: add new files under `assets/<bucket>/` and register the folder in `pubspec.yaml` if it's new.

---

## 15. Adding a New Screen — Checklist

1. File path: `lib/features/<feature>/presentation/screens/<name>_screen.dart`.
2. Use `ConsumerWidget` / `ConsumerStatefulWidget` if it reads providers.
3. Compose from `presentation/widgets/` — never inline large widget trees.
4. Register a `GoRoute` in the feature's `routes/` file.
5. Navigate via `context.goNamed('routeName')` / `context.pushNamed('routeName')` — never raw paths.

---

## 16. Naming Conventions

| Element | Convention | Example |
| --- | --- | --- |
| Folder | `snake_case` | `customer_app/` |
| Dart file | `snake_case.dart` | `auth_shell_screen.dart` |
| Screen file | `<name>_screen.dart` | `login_screen.dart` |
| Widget file | `<name>.dart` (descriptive) | `auth_phone_field.dart` |
| Provider file | `<name>_provider.dart` | `auth_provider.dart` |
| Controller file | `<name>_controller.dart` | `otp_controller.dart` |
| Route name | `lowerCamelCase` | `salesReport` |
| Class | `PascalCase` | `AuthShellScreen` |
| Variable / func | `lowerCamelCase` | `verifyOtp()` |
| Private members | leading `_` | `_buildTextTheme()` |

---

## 17. Quick "Where Does X Live?" Index

| You're looking for… | Path |
| --- | --- |
| App entry point | `lib/main.dart` |
| Startup hook | `lib/bootstrap.dart` |
| Router definition | `lib/core/router/router_provider.dart` |
| Color palette | `lib/core/theme/app_colors.dart` |
| Theme / typography | `lib/core/theme/app_theme.dart` |
| Animation helpers | `lib/core/utils/animation_utils.dart` |
| Responsive helpers | `lib/core/utils/responsive_utils.dart` |
| Reusable snackbar | `lib/shared/widgets/app_snackbar.dart` |
| Splash screen | `lib/features/splash/presentation/screens/splash_screen.dart` |
| Onboarding screen | `lib/features/onboarding/presentation/screens/onboarding_screen.dart` |
| Auth (login/register) | `lib/features/auth/presentation/screens/auth_shell_screen.dart` |
| OTP screen | `lib/features/auth/presentation/screens/otp_screen.dart` |
| Auth routes | `lib/features/auth/routes/auth_routes.dart` |
| Localization JSON | `lib/l10n/{en,gu,hi}.json` |
| App assets | `assets/<bucket>/` |
| Dependencies | `pubspec.yaml` |

---

## 18. Related Documentation

- `doc/PROJECT_STRUCTURE_GUIDE.md` — Higher-level guide with rationale and conventions.
- `doc/ABSOLUTE_RULEBOOK.md` — Non-negotiable rules for contributors (theme, routing, structure).
- `doc/SPLASH_SCREEN_IMPLEMENTATION.md` — Implementation notes for the splash screen.
