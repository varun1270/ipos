# IPOS Absolute Rulebook

Purpose: keep project structure, design system, and implementation consistency stable across all future changes.

## A) Non-Negotiable Rules

1. Follow feature-first structure only.
2. Follow existing Clean Architecture layering in each feature.
3. Follow centralized theme/colors/fonts always.
4. Follow route naming and registration consistency always.
5. Follow minimal-change principle (no unrelated edits).

## B) Structure Rules

- Global infrastructure: lib/core/
- Feature-specific logic: lib/features/<feature>/
- Shared reusable blocks: lib/shared/
- Database/offline internals: lib/database/

Feature layout:

- data/
- domain/
- presentation/
- routes/

Do not mix layers. UI should not own data access.

## C) UI Consistency Rules

Always:

- Use AppColors from lib/core/theme/app_colors.dart
- Use Theme.of(context).textTheme for text styles
- Use the app theme from lib/core/theme/app_theme.dart
- Respect configured Inter font family and text hierarchy

Never:

- hardcode random colors when AppColors already has tokens
- define one-off font families in screens
- create visual style drift between screens for same component types

## D) Routing Rules

- Register every new route in lib/core/router/router_provider.dart
- Use named routes and lowerCamelCase names
- Use goNamed or pushNamed for navigation
- Do not navigate to undeclared route names

## E) Page Creation Standard

When adding a new page:

1. Create screen in feature presentation/screens
2. Create reusable widgets in feature presentation/widgets
3. Add provider/controller when state is needed
4. Register route in router provider
5. Keep UI styles theme-driven

## F) API and Data Standard

- Core network setup goes in lib/core/network/
- Feature remote datasource goes in feature data/datasource
- Domain repository interface goes in feature domain/repositories
- Repository implementation goes in feature data/repositories

Data flow:

- presentation -> usecase -> repository -> datasource

## G) Required Pre-Work Check

Before implementing tasks, quickly verify these files:

- doc/PROJECT_STRUCTURE_GUIDE.md
- lib/core/router/router_provider.dart
- lib/core/theme/app_theme.dart
- lib/core/theme/app_colors.dart

## H) Completion Checklist

Before marking task complete:

1. Correct folder placement
2. Correct route registration
3. Theme/font consistency maintained
4. Naming conventions maintained
5. No unrelated file changes
