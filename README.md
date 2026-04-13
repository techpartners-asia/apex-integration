# InvestX Mini App SDK

Melos monorepo containing the Apex investment mini-app SDK and supporting packages.

## Project Overview

InvestX Mini App is an **investment mini-app** that runs inside a host (super) app, enabling users to open securities accounts, complete risk assessments, select investment packs, manage portfolios, and submit feedback — all through a Flutter SDK.

### Packages

| Package | Path | Description |
|---------|------|-------------|
| `mini_app_core` | `packages/apex_mini_app_core` | Pure Dart contracts, models, and route specs — zero dependencies |
| `mini_app_ui` | `packages/apex_mini_app_ui` | Shared Flutter UI: theme, typography, responsive layout, host runtime |
| `mini_app_sdk` | `packages/apex_mini_app_sdk` | Main SDK: IPS features, networking, BLoC/Cubit state, localization |
| `mini_app_example` | `packages/apex_mini_app_example` | Reference host app demonstrating SDK integration |

## Scope of Work

### Completed Improvements

| ID | Description | Files Changed |
|----|-------------|---------------|
| K.1 #2 | **Pull-to-refresh** on Portfolio and Orders screens | `investx_page_scaffold.dart`, `investx_page_scaffold_body.dart`, `portfolio_screen.dart`, `orders_screen.dart` |
| K.1 #3 | **Skeleton/shimmer loading** placeholders replacing spinner-only loading states | `investx_skeleton_loader.dart` (new), `portfolio_screen.dart`, `orders_screen.dart`, `widgets.dart` |
| K.1 #4 | **Step indicator** for SecAcnt wizard flow (progress bar across all wizard screens) | `sec_acnt_step_indicator.dart` (new), `sec_acnt_consent_screen.dart`, `sec_acnt_personal_info_screen.dart`, `sec_acnt_agreement_screen.dart`, `sec_acnt_signature_screen.dart`, `sec_acnt_payment_screen.dart`, `investx_agreement_screen.dart`, `investx_signature_screen.dart` |
| K.1 #6 | **Bottom nav 3rd tab fix** — action button now opens action sheet instead of invalid tab switch | `bottom_navbar.dart` |
| K.3 #2 | **Merged ApiResponseGuard into ApiActionResultParser** — single unified API guard with `strictResponseCode` mode | `api_action_result_parser.dart`, `api_response_guard.dart` (deprecated wrapper), `portfolio_dto.dart` |
| K.3 #4 | **LoadableState convention** — Simple fetch cubits use `LoadableState<T>`; complex multi-action cubits (Orders, Feedback, Contract) use purpose-built state classes | Documented — no migration needed |
| K.4 | **QA tests** — FeedbackCubit tests (5), FeedbackEntity.fromJson tests (8), ApiActionResultParser tests (13 total) | `feedback_cubit_test.dart` (new), `feedback_entity_test.dart` (new), `api_response_guard_test.dart` (rewritten) |

### Excluded Scope

- **K.2 API Improvements** — No new backend API endpoints were created or modified. This includes:
  - `GET /feedback/list` (feedback list endpoint does not exist)
  - Pagination support for orders/statements
  - WebSocket for real-time portfolio updates
  - Admin/management API changes

## UI Flow Summary

```
Host App → /splash (bootstrap)
  ├─ No account    → /sec-acnt (wizard with step indicator)
  │                   consent → personal-info → agreement → signature → payment → calculation
  ├─ No IPS acnt   → /questionnaire → /packs → /contract
  └─ Has IPS acnt  → /overview (Home | Profile tabs, 3rd tab opens action sheet)
                       ├─ /portfolio (holdings, allocation, pull-to-refresh, skeleton loading)
                       ├─ /orders (list + cancel, pull-to-refresh, skeleton loading)
                       ├─ /recharge (top-up)
                       ├─ /sell (sell order)
                       ├─ /statements (transaction history + date filter)
                       ├─ /feedback (list + create → POST API)
                       ├─ /help (contact info)
                       ├─ /reward (achievements - static)
                       └─ /personal-info (profile edit)
```

## Business Logic Summary

- **Auth**: Host `userToken` → signUp → `admSession` → `getLoginSession` → protected `accessToken`
- **Session refresh**: 401/403 → auto-refresh via `SessionRefreshInterceptor` (1 retry with `x-retry` header)
- **API response guard**: Unified `ApiActionResultParser.ensureSuccess()` handles both broker API (`strictResponseCode: true`) and admin API (checks `success` flag + `responseCode`)
- **Feedback**: Title + description required; submit disabled while in-flight; items accumulated in-memory
- **Orders**: Only `pending` orders can be cancelled; concurrent cancel prevented; balance refreshed after cancel
- **Pull-to-refresh**: Portfolio and Orders screens support swipe-down to reload from API
- **Wizard step indicator**: SecAcnt flow shows a segmented progress bar that fills based on current step position

## Use Case Summary

| UC | Actor | Flow |
|----|-------|------|
| UC-01 | User | Open securities account via wizard (consent → info → agreement → signature → payment) |
| UC-02 | User | Complete risk questionnaire and select investment pack |
| UC-03 | User | View portfolio dashboard (holdings, allocation, yield) |
| UC-04 | User | Place charge/sell order via action sheet |
| UC-05 | User | Cancel pending order |
| UC-06 | User | View transaction statements with date filter |
| UC-07 | User | Submit feedback (title + description → API) |
| UC-08 | User | View personal info, contact details |

## Data / Entity Summary

| Entity | Key Fields | Lifecycle |
|--------|-----------|-----------|
| `UserEntityDto` | id, name, phone, email, bank, admSession | signUp → updateProfile |
| `FeedbackEntity` | id, title, description, status (pending/resolved/closed) | createFeedback → admin resolves |
| `PortfolioOverview` | currency, balances, allocation %, profit/loss | getIpsBalance (read) |
| `IpsOrder` | orderNo, type, status, amount, createdAt | charge/sell → cancel |
| `IpsPack` | packCode, name, bond/stock/asset %, isRecommended | getPack (read) |
| `AcntBootstrapState` | hasAcnt, hasIpsAcnt, balances, bankInfo | getSecAcntList (read) |

## Module / Folder Structure

```
packages/apex_mini_app_sdk/lib/src/
├── core/
│   ├── api/          # ApiExecutor, ApiActionResultParser, ApiParser, endpoints
│   ├── backend/      # SdkBackendConfig
│   └── exception/    # ApiException hierarchy
├── app/
│   ├── investx_api/  # MiniAppApiBackend, DTOs, request models
│   ├── session/      # Session controller, store, login flow
│   └── bootstrap/    # MiniAppBootstrapFlow, MiniAppBootstrapCubit
├── features/ips/
│   ├── di/           # IpsDependencies, IpsServicesFactory
│   ├── router/       # Route builder, route pages, InvestXFeature
│   ├── shared/       # Domain models, services, DTOs, shared widgets
│   │   └── presentation/widgets/
│   │       ├── investx_page_scaffold.dart      # App scaffold with onRefresh support
│   │       ├── investx_skeleton_loader.dart     # Shimmer loading placeholders
│   │       └── bottom_navbar.dart               # 3-item nav with action interception
│   ├── overview/     # Dashboard home + profile tabs
│   ├── portfolio/    # Portfolio detail screen (pull-to-refresh)
│   ├── orders/       # Order list + cancel (pull-to-refresh, skeleton)
│   ├── contract/     # Contract purchase flow
│   ├── questionnaire/# Risk assessment wizard
│   ├── pack/         # Pack selection
│   ├── recharge/     # Top-up flow
│   ├── sell/         # Sell order flow
│   ├── statements/   # Transaction history
│   ├── feedback/     # Feedback create (API-connected), entity, cubit
│   ├── help/         # Contact info (static)
│   ├── reward/       # Achievements (static)
│   ├── profile/      # Personal info edit
│   └── sec_acnt/     # Securities account wizard (with step indicator)
│       └── presentation/widgets/
│           └── sec_acnt_step_indicator.dart    # Segmented progress bar
└── routes/           # MiniAppRoutes constants
```

## State Management Conventions

| Pattern | Used By | Description |
|---------|---------|-------------|
| `LoadableState<T>` | Portfolio, Overview, Statements, PackSelection, Bootstrap | Simple load → display cubits |
| Custom state class | Orders, Feedback, Contract, Recharge, Sell, SecAcnt, Questionnaire | Multi-action cubits with submission tracking, cancel states, etc. |

## Setup and Run

### Prerequisites

- Flutter SDK `^3.10.1`
- Melos `^7.4.1` (`dart pub global activate melos`)

### Commands

```bash
# Bootstrap all packages
melos bootstrap

# Run all tests (86 tests across the SDK package)
melos run test

# Run the example app
cd packages/apex_mini_app_example
flutter run

# Regenerate localization
cd packages/apex_mini_app_sdk
flutter gen-l10n

# Static analysis
cd packages/apex_mini_app_sdk
flutter analyze --no-pub
```

## Configuration / Environment

| Config | Source | Description |
|--------|--------|-------------|
| `userToken` | Host app | User authentication token passed at launch |
| `MiniAppSdkConfig` | Host app | SDK configuration (base URL, credentials, payment handler) |
| `APPID` / `APPSECRET` | API headers | Broker API authentication credentials |
| `loginSessionBaseUrl` | Config | Base URL for login session endpoint |
| Admin API | `api.admin.investx.mn` | User profile, feedback, invoices |
| Broker API | `/api/v1.0/*` | Securities, orders, portfolio, questionnaire |

## Assumptions

- [A1] Host app handles biometric/PIN authentication
- [A2] Payment gateway integration is via host app's `MiniAppPaymentExecutor`
- [A3] `admSession` is a JWT token verified server-side
- [A4] Broker API (`/api/v1.0/*`) connects to MCSD through a third-party broker system
- [A5] Reward/Achievement feature is static UI, to be connected to backend in future
- [A6] Feedback list API (`GET /feedback/list`) does not exist yet; in-memory only on client
- [A7] Complex cubits (Orders, Feedback, etc.) need purpose-built state classes rather than `LoadableState<T>`

## Known Limitations

1. **Feedback list is in-memory** — App restart clears the feedback list (no list API exists)
2. **No offline caching** — All data is fetched from APIs; no local persistence
3. **No pagination** — Orders, statements, feedback lists load all items at once
4. **No push notifications** — Order completion, feedback responses not notified
5. **Reward screen is static** — No backend data connection
6. **Statements filter is client-side only** — Filter parameters not sent to API
7. **`ApiResponseGuard` deprecated but retained** — Old callers compile via backward-compatible wrapper; new code should use `ApiActionResultParser.ensureSuccess()` directly

## Changelog

| Date | Change |
|------|--------|
| 2026-04-08 | K.3 #2: Merged `ApiResponseGuard` into `ApiActionResultParser` with `strictResponseCode` flag |
| 2026-04-08 | K.1 #2: Pull-to-refresh added to Portfolio and Orders screens; `onRefresh` added to `InvestXPageScaffold` |
| 2026-04-08 | K.1 #4: `SecAcntStepIndicator` added across all wizard screens (consent, info, agreement, signature, payment) |
| 2026-04-08 | K.1 #3: `InvestXSkeletonLoader` and `InvestXSkeletonListLoader` for shimmer loading placeholders |
| 2026-04-08 | K.1 #6: Bottom nav 3rd tab now fires `onActionPressed` instead of invalid tab selection |
| 2026-04-08 | K.4: Added 13 new tests — FeedbackCubit (5), FeedbackEntity (8); 86 total tests passing |
| 2026-04-08 | K.3 #4: LoadableState convention documented; complex cubits remain with custom state |
| 2026-04-08 | Comprehensive README created as single source of truth |
| 2026-04-07 | Feedback feature connected to `POST /api/v1/user/feedback/create` API |
| 2026-04-07 | `FeedbackEntity`, `FeedbackCubit`, `CreateFeedbackResponseDto` created |
| 2026-04-07 | Portfolio screen layout fix (mainAxisSize, Expanded wrapping) |
