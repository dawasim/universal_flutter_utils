# 🌟 universal\_flutter\_utils

A **powerful, all-in-one Flutter utility package** to boost productivity, maintain consistency, and speed up your app development.\
Includes beautifully crafted widgets, utilities, themes, extensions, API helpers, file pickers, and much more.

> ✅ Version: `0.0.9` 

---

## ✨ Features at a Glance

✅ Ready-to-use widgets (buttons, loaders, lists, bottom sheets, inputs, etc.)\
✅ Advanced UI: multi-select, responsive builder, shimmer, read more text, OTP input\
✅ Theme & typography management\
✅ File picker & file helper utilities\
✅ API & socket config with interceptors and AES encryption\
✅ String extensions, text helpers, validators, permissions, shared preferences\
✅ Cross-platform: Android, iOS, Web, macOS, Windows, Linux\
✅ Example app included!

---

## 📦 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  universal_flutter_utils: ^0.0.9
```

Then run:

```bash
flutter pub get
```

---

## ⚡ Quick Start

Import the package:

```dart
import 'package:universal_flutter_utils/universal_flutter_utils.dart';
```

Use ready-made widgets:

```dart
UFUButton(
  text: "Get Started",
  colorType: UFUButtonColorType.primary,
  textSize: UFUTextSize.heading2,
  fontWeight: UFUFontWeight.medium,
  radius: 12,
  onPressed: () => print("Button Pressed!"),
)
```

Use utilities:

```dart
List<XFile> fileList = await UFUtils.picker.selectImageFromGallery();
List<XFile> fileList = await UFUtils.picker.captureImageFromCamera();
UFUtils.textValidator(textInputController.text.trim(), isRequired: true, minCount: 3);
UFUtils.emailValidator(emailInputController.text.trim(), isRequired: true);
UFUtils.phoneValidator(phoneNoInputController.text.trim(), isRequired: true);
```

Use theme:

```dart
final theme = AppTheme.lightTheme;
```

---

## 🧩 Example Usage

The included `example` project shows:

- API calls with interceptors
- Picking and uploading files
- Using `UFUButton`, `UFUText`, `UFUInputBox`, etc.
- Theme setup & responsive builder

Run the example:

```bash
cd example
flutter run
```

---

## 🛠 API Docs (High-Level)

| Module           | What it offers                                                                  |
| ---------------- | ------------------------------------------------------------------------------- |
| `api_config/`    | AES encryption, request/response interceptors, API base config                  |
| `common/`        | Constants, enums (device type, run mode), helpers, services (cookies, firebase) |
| `extensions/`    | String extensions and method shortcuts                                          |
| `models/`        | Shared data models                                                              |
| `socket_config/` | Socket config and logging interceptors                                          |
| `theme/`         | Themes, theme colors, font weights, sizes, etc.                                 |
| `utils/`         | File helpers, validators, date/time utils, permissions, shared preferences      |
| `widgets/`       | Buttons, loaders, input boxes, OTP, shimmer, multi-select, list views, etc.     |

---

## 🎨 Widgets Highlights

✅ `UFUButton`, `UFUIconButton`, `UFUCheckbox`\
✅ `UFUMultiSelect`, `UFUSingleSelect`\
✅ `UFUReadMoreText`, `UFUOtpInputBox`, `UFUInputBox`\
✅ `UFUAvatar`, `UFUDashedBorder`, `UFUResponsiveBuilder`\
✅ `UFUNoDataFound`, `UFUToast`, `UFUPopUpMenuButton`\
✅ `UFUVideoPlayer`, `UFUNetworkImage`, `ShowUFULoader`, `UFUShimmer`\
✅ `ShowUFUBottomSheets`, `UFUScaffold`, `UFUListView`, and more!

---

## 🧰 Utilities Highlights

✅ AES encryption / decryption\
✅ File pickers (image, audio, any file)\
✅ Date & time formatting\
✅ Validators, text helpers, direction helpers\
✅ Shared preferences, cookie service, firebase service\
✅ Theme & color management\
✅ Social login helper stubs

---

## 📷 Assets & Fonts

- `assets/images/default_image.png`, `alt-image.png`
- `assets/folder.svg`
- Fonts: Can be set through `UFUtils.fontFamily = "RethinkSans";`

---

## 📂 Package Structure Overview

```plaintext
lib/
 ├── api_config/         → API helpers & encryption
 ├── common/             → Constants, enums, services
 ├── extensions/         → Dart & String extensions
 ├── models/             → Shared models
 ├── socket_config/      → Socket helpers
 ├── theme/              → Themes, colors, fonts
 ├── utils/              → Helpers (files, permissions, validators)
 ├── widgets/            → Buttons, lists, loaders, inputs, etc.
 └── universal_flutter_utils.dart → Entry point
```

---

## 📜 License

This project is licensed under the **MIT License** – see the [LICENSE](./LICENSE) file.

---

## 💡 Contributing

We welcome issues, feature requests, and pull requests!\
Feel free to help us make `universal_flutter_utils` even better.

---

## 🚀 Made with ❤️ to save your time & keep your Flutter code clean.

> 📦 Need help setting it up, or want detailed docs?\
> 👉 Feel free to open an issue or start a discussion!

