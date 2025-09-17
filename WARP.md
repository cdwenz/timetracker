# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

**ihadi_time_tracker** is a Flutter mobile application for daily work log tracking. The app allows users to log time entries with detailed information including supported persons, countries, languages, tasks, and time periods. It supports both online and offline functionality with a planned synchronization system.

## Essential Commands

### Development Setup
```bash
# Install dependencies
flutter pub get

# Run the app (debug mode)
flutter run

# Run on specific device
flutter devices
flutter run -d <device_id>

# Hot restart (when hot reload isn't enough)
flutter run --hot
```

### Testing & Quality Assurance
```bash
# Run all tests
flutter test

# Run a specific test file
flutter test test/widget_test.dart

# Analyze code for issues
flutter analyze

# Format code according to Dart standards
dart format .

# Check for outdated dependencies
flutter pub outdated
```

### Building & Deployment
```bash
# Build APK (debug)
flutter build apk

# Build APK (release)
flutter build apk --release

# Build iOS (requires macOS and Xcode)
flutter build ios

# Build for web
flutter build web

# Clean build artifacts
flutter clean && flutter pub get
```

## Architecture Overview

### Core Architecture Pattern
The app follows a **Provider + Services** architecture:

- **Provider Pattern**: State management using `Provider` package
- **Services Layer**: Business logic and API communication
- **Models**: Data structures with JSON serialization
- **Screens**: UI components organized by feature
- **Widgets**: Reusable UI components

### Key Architectural Components

#### State Management (`/lib/providers/`, `/lib/models/`)
- **TrackingData**: Central state for time tracking workflow (temporary data during form flow)
- **UserProvider**: User authentication state and session management
- **LanguageController**: Internationalization and locale management

#### Services Layer (`/lib/services/`)
- **ApiService**: Basic HTTP client for backend communication
- **TimeTrackerService**: Specialized service for time tracking API calls
- **AuthService**: User authentication and session management
- **LocalDatabase**: SQLite database operations (currently commented out, ready for offline implementation)

#### Data Models (`/lib/models/`)
- **Tracking**: Main model for time tracking records from API
- **TrackingEntry**: Local database model with offline sync capabilities (`synced` field)
- **UserProfile**: User account information

#### Screen Flow (`/lib/screens/`)
The app uses a **7-step tracking workflow**:
1. **Step 01**: Note and recipient information
2. **Step 02**: Supported country and working language
3. **Step 03**: Person name
4. **Step 04**: Date range selection
5. **Step 05**: Time range selection
6. **Step 06**: Task selection
7. **Step 07**: Task description and final submission

### API Integration
- Backend URL: `http://10.0.2.2:8000/api` (Android emulator localhost)
- Authentication: Bearer token stored in SharedPreferences
- Main endpoints: `/login`, `/register`, `/time-tracker`

### Offline Strategy (Planned Implementation)
- **Local Storage**: SQLite database via `sqflite` package
- **Sync Status**: TrackingEntry model includes `synced` field
- **Connectivity Detection**: `connectivity_plus` package for network monitoring
- **Queue System**: Local operations queue for when offline

## Development Guidelines

### Model Conventions
- All models should implement `toMap()` and `fromMap()`/`fromJson()` methods
- Use nullable fields appropriately with proper null checks
- TrackingEntry vs Tracking models serve different purposes:
  - **Tracking**: API response model
  - **TrackingEntry**: Local database model with sync capabilities

### State Management Patterns
- Use Provider for global state (user session, language, tracking data)
- Call `notifyListeners()` after state changes
- Access providers using `context.watch<T>()` in build methods
- Use `context.read<T>()` for one-time operations

### API Service Patterns
- All API calls should handle authentication tokens
- Use proper error handling with try-catch blocks
- Log API responses for debugging: `print('API response: ${response.statusCode} ${response.body}')`

### Testing Strategy
- Widget tests are in `/test/` directory
- Current test suite is basic - consider expanding for critical workflows
- Test both online and offline scenarios when implementing sync

### Localization Setup
- L10n configuration in `l10n.yaml`
- Template file: `lib/l10n/app_en.arb`
- Generated files: `lib/l10n/app_localizations*.dart`
- Language switching via LanguageController provider

## Current Development Focus

### Offline Implementation (In Progress)
Based on `OFFLINE_IMPLEMENTATION.md`, the current priority is implementing offline functionality:

1. **Database Setup**: Complete the SQLite implementation in `local_database.dart`
2. **Sync Service**: Build bidirectional synchronization between local and remote data
3. **Connectivity Detection**: Implement network status monitoring
4. **UI Indicators**: Add offline/online status indicators
5. **Conflict Resolution**: Handle data conflicts during sync

### Key Files for Offline Work
- `lib/services/local_database.dart` - SQLite implementation (currently commented out)
- `lib/models/tracking_entry.dart` - Already has `synced` field for offline support
- Dependencies already added: `sqflite: ^2.4.2`, `connectivity_plus: ^7.0.0`

### Model Unification Needed
The codebase has two similar models that need reconciliation:
- **Tracking** (API model)
- **TrackingEntry** (Local model with sync support)

Consider creating a unified model or clear mapping between them.

## Common Debugging Tips

### Android Emulator Issues
- Backend URL `10.0.2.2:8000` maps to localhost on development machine
- For physical devices, use actual IP address of development machine

### State Management Debugging
- Use Flutter Inspector to monitor Provider state changes
- Add debug prints in `notifyListeners()` calls to trace state updates

### API Debugging
- Enable network logging to see HTTP requests/responses
- Check SharedPreferences for stored tokens: `prefs.getString('access_token')`

### Hot Reload Limitations
- Provider state changes may require hot restart
- Database schema changes always require full restart

## Dependencies Overview

### Core Flutter
- `flutter_localizations`: Internationalization support
- `provider: ^6.1.2`: State management
- `shared_preferences: ^2.2.2`: Local data persistence
- `http: ^0.13.6`: HTTP client
- `intl: ^0.20.2`: Internationalization utilities

### Database & Offline
- `sqflite: ^2.4.2`: SQLite database
- `connectivity_plus: ^7.0.0`: Network connectivity detection
- `path: ^1.9.1`: File path utilities

### Development & Testing
- `flutter_lints: ^3.0.1`: Linting rules
- `flutter_test`: Testing framework (SDK)

## File Organization
```
lib/
├── main.dart                 # App entry point with providers setup
├── models/                   # Data models
├── services/                 # Business logic and API communication  
├── providers/                # State management
├── screens/                  # UI screens organized by feature
│   └── tracking_steps_screens/  # 7-step tracking workflow
├── widgets/                  # Reusable UI components
├── utils/                    # Utility functions
├── localization/             # Language management
└── l10n/                     # Generated localization files
```