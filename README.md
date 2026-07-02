# universal_flutter_utils

[![pub package](https://img.shields.io/pub/v/universal_flutter_utils.svg)](https://pub.dev/packages/universal_flutter_utils)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A **production-ready Flutter UI toolkit and utilities package** for building mobile, web, and desktop apps faster. Includes reusable **widgets**, **Dio API helpers**, **Firebase authentication**, **file pickers**, **form validators**, **themes**, **socket.io**, **maps**, and more — all in one import.

> Version: `0.0.10-beta.1` · [View on pub.dev](https://pub.dev/packages/universal_flutter_utils)

---

## Why use this package?

Stop rebuilding the same Flutter boilerplate in every project. `universal_flutter_utils` bundles the UI components and backend helpers most apps need:

- **Flutter widgets** — buttons, inputs, loaders, bottom sheets, lists, avatars, shimmer, OTP, video player
- **Form validation** — email, phone, password, required field, and custom validators
- **Networking** — Dio HTTP client with interceptors, AES encryption, retry, and error handling
- **Real-time** — Socket.io configuration with logging interceptors
- **Firebase** — auth, crashlytics, push notifications (FCM), and messaging setup
- **Authentication** — Google Sign-In, Apple Sign-In, Facebook login, and biometric (fingerprint / Face ID)
- **File picker** — image, camera, audio recording, document upload, and file helpers
- **Maps & location** — place picker, Google Maps autocomplete, geolocation utilities
- **Theming** — light/dark themes, typography, colors, responsive layout builder
- **Cross-platform** — Android, iOS, Web, macOS, Windows, Linux

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  universal_flutter_utils: ^0.0.10-beta.1
```

Then run:

```bash
flutter pub get
```

---

## Quick Start

Import the package:

```dart
import 'package:universal_flutter_utils/universal_flutter_utils.dart';
```

### Flutter UI widgets

```dart
UFUButton(
  text: "Get Started",
  colorType: UFUButtonColorType.primary,
  textSize: UFUTextSize.heading2,
  fontWeight: UFUFontWeight.medium,
  radius: 12,
  onPressed: () => print("Button Pressed!"),
)

UFUInputBox(
  hintText: "Email",
  controller: emailController,
)

UFUOtpInputBox(onCompleted: (otp) => verifyOtp(otp))

ShowUFULoader(msg: "Loading...")
ShowUFUBottomSheet(child: (controller) => YourWidget())
```

### Form validators

```dart
UFUtils.textValidator(text, isRequired: true, minCount: 3);
UFUtils.emailValidator(email, isRequired: true);
UFUtils.phoneValidator(phone, isRequired: true);
```

### File picker

```dart
List<XFile> images = await UFUtils.picker.selectImageFromGallery();
List<XFile> photos = await UFUtils.picker.captureImageFromCamera();
```

### Theme

```dart
final theme = AppTheme.lightTheme;
MaterialApp(theme: theme, ...);
```

---

## Widgets

| Category | Components |
| -------- | ---------- |
| **Buttons** | `UFUButton`, `UFUIconButton`, `UFUTextButton`, `UFUCheckbox` |
| **Inputs** | `UFUInputBox`, `UFUOtpInputBox`, debounced search input |
| **Selection** | `UFUMultiSelect`, `UFUSingleSelect`, `UFUPopUpMenuButton` |
| **Layout** | `UFUScaffold`, `UFUListView`, `UFUResponsiveBuilder`, `UFUDashedBorder` |
| **Feedback** | `ShowUFULoader`, `UFUToast`, `UFUShimmer`, `UFUNoDataFound` |
| **Dialogs** | `ShowUFUConfirmationDialog`, `ShowUFUBottomSheet`, `ShowRecordingDialog` |
| **Media** | `UFUNetworkImage`, `UFUVideoPlayer`, `UFUAvatar`, image cropper |
| **Text** | `UFUText`, `UFUReadMoreText`, selectable text support |
| **Maps** | Place picker, Google Maps autocomplete, location helpers |
| **Pickers** | Image picker, file picker, audio recorder bottom sheet |

---

## Utilities

| Category | What it offers |
| -------- | -------------- |
| **API / Dio** | `api_config/` — AES encryption, request/response/error interceptors, file upload |
| **Socket.io** | `socket_config/` — connection config and logging interceptors |
| **Validators** | Email, phone, password, required fields, custom rules |
| **File helpers** | Gallery, camera, audio, multi-file upload, file preparation |
| **Date & time** | Formatting and parsing utilities |
| **Permissions** | Camera, storage, location, notification permission handling |
| **Preferences** | Shared preferences wrapper for tokens, language, settings |
| **Biometric** | Fingerprint and Face ID authentication |
| **Social login** | Google, Apple, Facebook sign-in helpers |
| **Firebase** | Auth, Crashlytics, FCM push notifications |
| **Extensions** | String helpers, card number formatter, input box extensions |
| **Theme** | `AppTheme`, `ThemeColors`, font weights, text sizes, form UI helper |

---

## Package Structure

```plaintext
lib/
 ├── api_config/         → Dio HTTP client, AES encryption, interceptors
 ├── common/             → Constants, enums, Firebase & cookie services
 ├── extensions/         → String and input formatters
 ├── models/             → Address, contact, shared data models
 ├── socket_config/      → Socket.io helpers
 ├── theme/              → Themes, colors, typography
 ├── utils/              → Validators, file picker, permissions, preferences
 ├── widgets/            → UI components (buttons, inputs, lists, maps, etc.)
 └── universal_flutter_utils.dart → Single entry-point export
```

---

## Example App

The included `example/` project demonstrates:

- API calls with Dio interceptors and encryption
- File picking and uploading
- `UFUButton`, `UFUText`, `UFUInputBox`, and other widgets
- Theme setup and responsive layout

```bash
cd example
flutter run
```

---

## Search & Discoverability

This package is tagged for pub.dev topics: **widgets**, **utilities**, **ui**, **networking**, **authentication**.

Common searches this package helps with:

`flutter widgets` · `flutter ui kit` · `dio interceptor` · `flutter form validation` · `flutter file picker` · `flutter bottom sheet` · `flutter otp input` · `flutter multi select` · `flutter shimmer` · `firebase auth flutter` · `socket.io flutter` · `flutter theme` · `google maps place picker` · `flutter biometric auth` · `social login flutter` · `flutter utilities`

---

## License

MIT License — see [LICENSE](./LICENSE).

---

## Contributing

Issues, feature requests, and pull requests are welcome on [GitHub](https://github.com/dawasim/universal_flutter_utils/issues).

Made with care to save your time and keep Flutter code clean.
