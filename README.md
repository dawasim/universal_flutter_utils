# universal_flutter_utils

[![pub package](https://img.shields.io/pub/v/universal_flutter_utils.svg)](https://pub.dev/packages/universal_flutter_utils)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A **production-ready Flutter UI toolkit and utilities package** for building mobile, web, and desktop apps faster. It bundles reusable **widgets**, **Dio API helpers**, **Firebase & push notifications**, **authentication**, **file/media pickers**, **maps & location**, **form validators**, **theming**, **Socket.io**, and cross-platform helpers — all behind a single import.

> Version: `0.0.11` · [View on pub.dev](https://pub.dev/packages/universal_flutter_utils) · [API docs](https://pub.dev/documentation/universal_flutter_utils/latest/)

---

## Why use this package?

Most Flutter apps repeat the same building blocks: styled buttons, OTP inputs, bottom sheets, Dio interceptors, file upload flows, permission prompts, and Firebase setup. `universal_flutter_utils` packages those patterns so you can focus on business logic instead of boilerplate.

**Designed for real production apps** — the included `example/` app shows how teams typically wire things up: configure `UFUtils` once at startup, theme via `AppTheme`, then use widgets and helpers throughout screens.

**Single entry point** — one import exposes widgets, utilities, models, theme, extensions, and networking:

```dart
import 'package:universal_flutter_utils/universal_flutter_utils.dart';
```

**Cross-platform** — Android, iOS, Web, macOS, Windows, and Linux.

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  universal_flutter_utils: ^0.0.11
```

Then run:

```bash
flutter pub get
```

---

## App Setup (Recommended Pattern)

Based on the included example app, configure global settings once in `initState` or before `runApp`:

```dart
void main() {
  runApp(const MyApp());
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // App identity & API endpoints
    UFUtils.appName = "My App";
    UFUtils.baseUrl = "https://api.example.com/";
    UFUtils.socketBaseUrl = "wss://socket.example.com";

    // Optional: encryption, token refresh, navigation on 401
    UFUtils.applyEncryption = true;
    UFUtils.refreshToken = () async { /* refresh auth token */ };
    UFUtils.refreshDestination = "/login";

    // Brand colors — used across all UFU widgets automatically
    AppTheme.themeColors.primary = Color(0xff9381ff);
    AppTheme.themeColors.secondary = Color(0xffb8b8ff);
    AppTheme.themeColors.tertiary = Color(0xffffd8be);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: UFUtils.appName,
      theme: ThemeData(useMaterial3: true),
      home: HomePage(),
    );
  }
}
```

---

## Quick Start

### UI widgets

```dart
UFUButton(
  text: "Get Started",
  colorType: UFUButtonColorType.primary,
  textSize: UFUTextSize.heading2,
  fontWeight: UFUFontWeight.medium,
  radius: 12,
  onPressed: () {},
)

UFUInputBox(hintText: "Email", controller: emailController)

UFUOtpInputBox(onCompleted: (otp) => verifyOtp(otp))

ShowUFULoader(msg: "Loading...")

ShowUFUBottomSheet(
  child: (controller) => YourWidget(),
)
```

### Form validators

```dart
UFUtils.textValidator(text, isRequired: true, minCount: 3);
UFUtils.emailValidator(email, isRequired: true);
UFUtils.phoneValidator(phone, isRequired: true);
UFUtils.passwordValidator(password, isRequired: true);
UFUtils.confirmPasswordValidator(confirm, password: password);
```

### File & media pickers

```dart
List<XFile> images = await UFUtils.picker.selectImageFromGallery(selectMultiple: true);
List<XFile> photos = await UFUtils.picker.captureImageFromCamera();
String? docPath = await UFUtils.picker.selectDocument();
dynamic audio = await UFUtils.picker.recordAudio();
String? contact = await UFUtils.picker.selectContacts();
DateTime? date = await UFUtils.picker.selectDate();
TimeOfDay? time = await UFUtils.picker.selectTime();
```

### API calls

```dart
final api = UFApiConfig();
final data = await api.get('/users');
await api.post('/auth/login', data: {'email': email, 'password': password});
await api.uploadFile(path: '/upload', file: file, fileParam: 'file');
```

### Firebase & notifications

```dart
await UFUtils.firebaseUtils.initFirebase(
  options: DefaultFirebaseOptions.currentPlatform,
  notificationTap: (payload) => handleNotification(payload),
);
UFUtils.firebaseUtils.initFCMToken();
```

### Socket.io

```dart
await UFSocketConfig.initializeSocket(
  initListeners: ({required socket, required on}) {
    on('message', (data) => print(data));
  },
);
UFSocketConfig.send('event', {'key': 'value'});
```

---

## Facilities Overview

Everything below is available from the single package import.

### UI Widgets

| Category | Components | Details |
| -------- | ---------- | ------- |
| **Buttons** | `UFUButton`, `UFUIconButton`, `UFUTextButton` | Size, radius, color types, gradient support via `UFUtils.buttonGradient` |
| **Inputs** | `UFUInputBox`, `UFUOtpInputBox`, `UFUCheckbox` | Built-in clear icon, debounced search (`Debounce`), custom input types |
| **Selection** | `UFUMultiSelect`, `UFUSingleSelect`, `UFUPopUpMenuButton` | Local & network-backed lists, search, load-more, sub-lists, tag modal, max selection |
| **Layout** | `UFUScaffold`, `UFUListView`, `UFUResponsiveBuilder`, `UFUDashedBorder` | Gradient scaffold, tap-to-dismiss keyboard, paginated list/grid with pull-to-refresh |
| **Feedback** | `ShowUFULoader`, `UFUToast`, `UFUShimmer`, `UFUNoDataFound` | Custom loader dialog, shimmer placeholders, empty states |
| **Dialogs & sheets** | `ShowUFUConfirmationDialog`, `ShowUFUBottomSheet`, `ShowRecordingDialog` | Adaptive popover on tablet/desktop, bottom sheet on mobile, unsaved-changes flow |
| **Media** | `UFUNetworkImage`, `UFUVideoPlayer`, `UFUAvatar`, `UFUImageCropper` | Cached images, Chewie video player, circle/square/ratio crop (16:7, 1:1, 5:3) |
| **Text & HTML** | `UFUText`, `UFUTextSpan`, `UFUReadMoreText`, `UFUHtmlViewer` | Typography system, expandable text, styled HTML rendering |
| **Files & thumbs** | `UFUThumb`, `UFUSvgImage` | 30+ file-type icons (pdf, docx, xlsx, zip, dwg, etc.), folder/image thumbs |
| **Maps & location** | `UFULocationPicker`, `UFUPlaceAutoComplete` | Google Maps place picker, address autocomplete, geocoding into `UFUAddressModel` |
| **Animations** | `UFUAnimatedSpinKit`, scale animations | Three-bounce, fading-circle loaders, scale in/out effects |
| **Misc** | `UFULoadMoreButton`, custom list bottom sheet, image/file picker widgets | Pagination helper, reusable sheet patterns |

### Networking (`UFApiConfig`)

| Feature | Description |
| ------- | ----------- |
| **HTTP verbs** | `get`, `post`, `put`, `patch`, `delete` with unified error handling |
| **AES encryption** | Optional request body encryption via `EncryptionUtil` (`UFUtils.applyEncryption`) |
| **Interceptors** | Request, response, and error interceptors for auth headers, logging, and token injection |
| **File upload** | Single (`uploadFile`) and multi-file (`uploadMultiFile`) multipart uploads with bearer auth |
| **File download** | `downloadFile` with progress callback, platform-aware save location |
| **Timeouts** | Configurable connect/receive timeouts; `infiniteTimeout` flag for long operations |
| **Retry helper** | `Retry.execute()` with cooldown and cancellable delayed retry |

### Real-time (`UFSocketConfig`)

| Feature | Description |
| ------- | ----------- |
| **Connection** | WebSocket transport with auto-reconnect and force-new connection |
| **Auth** | Sends auth token from shared preferences in headers |
| **Events** | `send`, `on`, default connect/disconnect/error listeners |
| **Interceptors** | Pluggable interceptor manager with built-in logging interceptor |

### Authentication & Security

| Feature | Description |
| ------- | ----------- |
| **Social login** | `UFUSocialLogin` — Google Sign-In, Apple Sign-In, Facebook login via Firebase Auth |
| **Biometric** | `UFUBiometricRecognition` — fingerprint / Face ID support check and validation |
| **Token storage** | `UFPrefUtils` — auth token, refresh token, remember-me, user data persistence |
| **401 handling** | `UFUtils.handleError` — automatic token refresh callback and route redirect on unauthorized |

### Firebase & Push Notifications

| Feature | Description |
| ------- | ----------- |
| **Firebase init** | `UFFirebaseUtils.initFirebase()` with platform-specific options |
| **FCM token** | Token retrieval, APNS support on Apple platforms, token refresh listener |
| **Local notifications** | `UFNotificationUtils` — Android, iOS, macOS, Linux, and Windows notification setup |
| **Foreground/background** | FCM message listener, background handler, tap-to-navigate payload storage |
| **Crashlytics** | Non-Dio errors logged with user ID, screen route, and app version context |

### File, Media & Device Pickers (`UFUtils.picker`)

| Feature | Description |
| ------- | ----------- |
| **Gallery & camera** | Single/multi image pick with optional compression |
| **Documents** | Custom extension filtering (pdf, doc, docx, png, jpg, jpeg, etc.) |
| **Audio recording** | Waveform-based recording dialog with microphone permission handling |
| **Contacts** | Native contact picker returning JSON-encoded `ContactModel` |
| **Date & time** | Themed date/time pickers aligned with `AppTheme` colors |
| **Permissions** | Automatic permission checks with "open settings" dialog on permanent denial |
| **File helpers** | Extension detection, file-type icon mapping, size limits, folder structure rules |

### Maps & Location

| Feature | Description |
| ------- | ----------- |
| **Place picker** | Full-screen map with search, pin drag, and address decode (`UFULocationPicker`) |
| **Autocomplete** | Inline Google Places search with debounce (`UFUPlaceAutoComplete`) |
| **Current location** | `UFUtils.fetchCurrentLocation()` with permission and GPS service checks |
| **Map launcher** | Open address in external maps app (`UFUtils.launchMapIntent`) |
| **Address model** | `UFUAddressModel` — structured address with lat/lng, city, state, postcode |
| **Local IP info** | `UFULocalRepo` — fetch geolocation from IP via ip-api.com |

### Form Validation & Data Helpers

| Validator / Helper | Description |
| ------------------ | ----------- |
| **Email** | Required check + regex validation |
| **Phone** | Required check + customizable regex |
| **Password** | 8–12 chars, uppercase, lowercase, number, special character rules |
| **Confirm password** | Match validation against original password |
| **Text** | Required + minimum length |
| **Date/time** | Format, parse, `timeAgo`, `dayWishes` greeting |
| **Numbers** | Comma-separated number formatting |
| **HTML** | Strip/parse HTML to plain text |
| **Clipboard** | Copy text to clipboard |
| **Card number** | Format with spaces every 4 digits + input formatter extension |
| **Grouping** | `UFUtils.groupBy()` for list grouping |
| **RTL** | `UFUtils.isRtl` via `DirectionHelper` |

### Permissions (`UFUtils.permissionUtils`)

Handles request flows for: storage, camera, photos, notifications, location, contacts, audio, microphone, and videos — with individual or batch (`getAllPermissions`) request methods.

### Theming (`AppTheme`)

| Feature | Description |
| ------- | ----------- |
| **Light / dark** | `AppTheme.setTheme(isDark)` toggles full color palette |
| **Custom colors** | 40+ semantic colors (primary, success, warning, gradients, status colors) |
| **Typography** | `UFUTextSize`, `UFUFontWeight`, `UFUFontFamily` used consistently across widgets |
| **Form styling** | `FormUiHelper` for consistent form field appearance |
| **Responsive** | `UFUScreen`, `UFUResponsiveDesign` breakpoints for mobile / tablet / desktop |

### Extensions

| Extension | Description |
| --------- | ----------- |
| **String** | `capitalize()`, decimal formatting via `formatUpTo()` |
| **Card number** | Input formatter for credit card fields |
| **No leading zero** | Formatter to prevent leading zeros in numeric inputs |
| **Input box** | Convenience extensions on input controllers |

### Models

| Model | Description |
| ----- | ----------- |
| `UFUAddressModel` | Structured address with JSON serialization |
| `ContactModel` | Native contact data wrapper |
| `UFULocalInfoModel` | IP-based location info |
| `PopoverAction` | Action item for popover menus |
| `UFUMultiSelectModel` | Item model for single/multi select lists |
| Network multiselect params | Request params for server-driven select lists |

### Common Services & Constants

| Module | Description |
| ------ | ----------- |
| `CookiesService` | Parse and store CloudFront cookies for authenticated CDN requests |
| `RunMode` | App vs unit/integration testing mode enum |
| `DeviceType` | Mobile, tablet, desktop detection |
| Pagination constants | Shared list pagination defaults |
| Widget keys | Predefined keys for testing and widget finding |

---

## Package Structure

```plaintext
lib/
 ├── api_config/          → UFApiConfig, AES encryption, Dio interceptors, retry
 ├── common/              → Constants, enums, cookies, Firebase, social login, notifications
 ├── extensions/          → String helpers, input formatters
 ├── models/              → Address, contact, local info, select list models
 ├── socket_config/       → UFSocketConfig, socket interceptors
 ├── theme/               → AppTheme, ThemeColors, typography, form UI helper
 ├── utils/               → UFUtils hub — validators, picker, permissions, preferences
 ├── widgets/             → 40+ UI components (buttons, inputs, lists, maps, media, etc.)
 └── universal_flutter_utils.dart → Single entry-point export
```

---

## Example App

The `example/` project is the reference implementation. It demonstrates:

| Screen | What it shows |
| ------ | ------------- |
| **Widgets Sample** | Buttons, text styles, icon buttons, single/multi select, avatars, paginated list view, profile image edit |
| **API Sample** | POST login/token request and GET request using `UFApiConfig` with `GetX` controller |
| **File Picker** | Document pick, gallery, camera, audio recording, contact pick, date & time pickers |

Run it:

```bash
cd example
flutter pub get
flutter run
```

Typical integration pattern from the example:

```dart
// Navigate to feature screens built with UFU widgets
UFUButton(text: "Widgets Sample", onPressed: () => Get.to(WidgetsSamples()));
UFUButton(text: "API Sample", onPressed: () => Get.to(APISampleCalls()));
UFUButton(text: "File Picker", onPressed: () => Get.to(FilePicker()));
```

---

## Typical Production Workflows

### Paginated list with pull-to-refresh

```dart
UFUListView(
  listCount: items.length,
  onRefresh: () => controller.fetchPage(reset: true),
  onLoadMore: () => controller.fetchPage(),
  isLoading: controller.isLoading,
  shimmerBuilder: (_, __) => UFUShimmer(...),
  noDataText: "No results found",
  itemBuilder: (context, index) => ItemTile(item: items[index]),
)
```

### Network-backed multi-select filter

```dart
UFUMultiSelect(
  title: 'Select categories',
  type: UFUMultiSelectType.network,
  mainList: categories,
  onSearch: (query) => controller.searchCategories(query),
  onLoadMore: () => controller.loadMoreCategories(),
  onDone: (selected) => applyFilter(selected),
)
```

### Confirmation before destructive action

```dart
ShowUFUConfirmationDialog(
  title: 'Delete item?',
  subTitle: 'This action cannot be undone.',
  prefixBtnText: 'Cancel',
  suffixBtnText: 'Delete',
  onTapSuffix: () => deleteItem(),
);
```

### Image pick → crop → upload

```dart
final images = await UFUtils.picker.captureImageFromCamera();
if (images.isNotEmpty) {
  final cropped = await Get.to(() => UFUImageCropper(
    imagePath: images.first.path,
    cropShape: UFUImageCropShape.circle,
    cropRatio: UFUImageCropRatio.ratio1x1,
  ));
  if (cropped != null) {
    await UFApiConfig().uploadFile(path: '/avatar', file: File(cropped), fileParam: 'file');
  }
}
```

---

## Platform Support

| Platform | Widgets | File picker | Firebase / FCM | Biometric | Maps |
| -------- | ------- | ----------- | -------------- | --------- | ---- |
| Android  | ✅ | ✅ | ✅ | ✅ | ✅ |
| iOS      | ✅ | ✅ | ✅ | ✅ | ✅ |
| Web      | ✅ | ✅ | ✅ | — | ✅ |
| macOS    | ✅ | ✅ | ✅ | ✅ | — |
| Windows  | ✅ | ✅ | Partial | — | — |
| Linux    | ✅ | ✅ | Partial | — | — |

---

## Search & Discoverability

Pub.dev topics: **widgets**, **utilities**, **ui**, **networking**, **authentication**.

Common searches this package helps with:

`flutter widgets` · `flutter ui kit` · `dio interceptor` · `flutter form validation` · `flutter file picker` · `flutter bottom sheet` · `flutter otp input` · `flutter multi select` · `flutter shimmer` · `firebase auth flutter` · `socket.io flutter` · `flutter theme` · `google maps place picker` · `flutter biometric auth` · `social login flutter` · `flutter utilities` · `flutter pagination list` · `flutter image cropper` · `flutter push notifications`

---

## License

MIT License — see [LICENSE](./LICENSE).

---

## Contributing

Issues, feature requests, and pull requests are welcome on [GitHub](https://github.com/dawasim/universal_flutter_utils/issues).

Made with care to save your time and keep Flutter code clean.
