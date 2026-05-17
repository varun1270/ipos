# IPOS Copilot Absolute Rules

These are mandatory project rules for all code changes.

## 1) Core Priority Order

Always follow this order:

1. Project structure rules
2. Existing architecture and feature boundaries
3. Theme and design consistency
4. Naming and routing consistency
5. Minimal safe change with no unrelated refactor

## 2) Required First Read (Before Editing)

Before making changes, review:

- doc/PROJECT_STRUCTURE_GUIDE.md
- lib/main.dart
- lib/core/router/router_provider.dart
- lib/core/theme/app_theme.dart
- lib/core/theme/app_colors.dart

If task includes auth, also review:

- lib/features/auth/

If task includes network/API, also review:

- lib/core/network/
- feature data/domain folders for that module

## 3) Folder and Architecture Rules

Use feature-first organization and keep boundaries strict:

- Shared app infrastructure -> lib/core/
- Business features -> lib/features/<feature_name>/
- Reusable cross-feature code -> lib/shared/
- Local DB scaffolding -> lib/database/

Inside each feature, keep layers separated:

- data/: datasources, models/dto, repository implementations
- domain/: entities, repository contracts, usecases
- presentation/: screens, widgets, providers/controllers
- routes/: feature route constants or route builders

Do not place feature logic directly in lib/core unless it is truly global.

## 4) UI and Theme Rules (Mandatory)

Always use centralized theme and color tokens:

- Use AppColors from lib/core/theme/app_colors.dart
- Use Theme.of(context).textTheme for text styles
- Prefer styles already configured in lib/core/theme/app_theme.dart

Do not hardcode UI tokens when a shared token exists:

- no random hex colors
- no ad-hoc font family definitions per screen
- no inconsistent button/input radius/padding if theme already defines it

Typography:

- Primary font family is Inter (configured in pubspec and theme)
- Keep hierarchy consistent with textTheme roles (headline/title/body/label)

## 5) Routing and Navigation Rules

All app routes must be registered in:

- lib/core/router/router_provider.dart

Rules:

- Add named routes for every new screen
- Use lowerCamelCase route names
- Prefer goNamed/pushNamed usage
- Never navigate to names not declared in router

If a screen exists and is navigated to, confirm route registration in the same change.

## 6) New Page Creation Rules

When creating a new page:

1. Create screen under feature presentation/screens
2. Add feature widgets under presentation/widgets
3. Add state providers/controllers if needed
4. Register route in router_provider.dart
5. Use AppColors + textTheme only (no visual drift)
6. Keep naming pattern snake_case with suffixes (\_screen, \_widget, \_provider)

## 7) API and Data Rules

API definitions should follow this shape:

- Core client/endpoints/interceptors in lib/core/network/
- Feature remote datasource in lib/features/<feature>/data/datasource/
- Domain repository contract in domain/repositories/
- Data repository implementation in data/repositories/

Flow to preserve:

- presentation -> usecase -> repository contract -> datasource

Do not call raw HTTP directly from UI screens.

## 8) Consistency Rules

Always maintain:

- Existing naming style
- Existing folder conventions
- Existing route naming style
- Existing theming style
- Existing spacing and component patterns used in nearby files

Avoid:

- introducing parallel patterns for the same purpose
- moving files without reason
- touching unrelated files

## 9) Safety and Scope Rules

- Keep changes minimal and task-focused.
- Do not break existing imports/routes.
- If structure mismatch is found (example: route points to missing file), either:
  - fix in the same change, or
  - clearly document blocker and propose exact fix path.

## 10) Output Quality Checklist (Every Task)

Before finishing, verify:

1. Folder placement is correct
2. Route is registered (if screen added)
3. Theme/AppColors/textTheme used consistently
4. Naming conventions are followed
5. No unrelated edits are made
