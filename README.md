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
