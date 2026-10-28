# universal_flutter_utils — Complete Implementation Guide (for developers and AI agents)

> Version documented: **0.0.13** (source-verified against `lib/`).
> Purpose: a single reference so that a project (or an AI module) can build **all UI and app plumbing through this package only**.
> Naming: public classes are prefixed `UFU` (widgets/models), `UF` (services/utilities). Static hub = `UFUtils`.

---

## 0. RULES FOR AI AGENTS / CODE GENERATORS (read first)

1. **Use `UFU*` widgets instead of raw Flutter widgets** for text, buttons, inputs, checkboxes, icons, loaders, toasts, dialogs, bottom sheets, lists, selects, avatars, images, scaffolds. Do not use `Text`, `ElevatedButton`, `TextField`, `showModalBottomSheet`, `Fluttertoast`, `Dio()` directly if a UFU equivalent exists (table in §3).
2. **The app MUST be a `GetMaterialApp`** (GetX). The package uses `Get.context`, `Get.bottomSheet`, `Get.dialog`, `Get.back`, `.tr`, `Get.arguments`. A plain `MaterialApp` will break dialogs, loaders, toasts (desktop), pickers, error handling.
3. **Configure once at startup** via `UFUtils.*` and `AppTheme.*` (§2). Never hardcode base URLs/colors in widgets.
4. **Colors always come from `AppTheme.themeColors.<name>`** (never `Colors.*`/hex) so brand changes propagate.
5. **Text sizes/weights use enums** `UFUTextSize` / `UFUFontWeight` (not raw doubles) unless `dynamicFontSize` is required.
6. **Networking only through `UFApiConfig`** (needs explicit import – see §1). Persist tokens only through `UFUtils.preferences`.
7. **Show loaders with `ShowUFULoader()` and always hide with `UFUtils.hideLoaderDialog()`** (or `Get.back()`).
8. **Dialogs/sheets that return values**: close with `Get.back(result: value)`; the `Show…` function returns that value.
9. **Several types are NOT re-exported by the main barrel** — add the explicit import listed in §1 or the code will not compile.
10. Read the **Known gotchas** (§17) before generating code that touches lists, file helpers, encryption, or video.

---

## 1. Installation & imports

```yaml
dependencies:
  universal_flutter_utils: ^0.0.13
  get: ^4.7.3          # app must use GetMaterialApp
```
Requires Dart `^3.12.0`, Flutter `>=3.44.0`. Platforms: Android, iOS, Web, macOS, Windows, Linux.

```dart
import 'package:universal_flutter_utils/universal_flutter_utils.dart';  // main barrel
```

### 1.1 What the main barrel exports
`UFUtils`, all widgets (except those below), `AppTheme`/`ThemeColors`/`FormUiHelper`/`ThemeModel`, `UFUColor`, enums (`UFUTextSize`, `UFUFontWeight`, `UFUFontFamily`, `UFUOrientation`, `UFUPosition`, `UFUDuration`, `DeviceType`, `RunMode`, `UFUNetworkMultiSelectType`, `UFUConfirmationDialogType`), `TextHelper`, `UFUScreen`, `UFUResponsiveDesign`, `UFUWidgetKeys`, `PaginationConstants`, `FileUploadStatus/Type/SupportedFiles`, `CookiesService`, `RunModeService`, `UFUSocialLogin`, `UFNotificationUtils`, `UFUBiometricRecognition`, `UFSocket`/`UFSocketConfig`, `ContactModel`, `UFUNetworkMultiSelectParams`, `PopoverActionModel`, extensions (`String.capitalize/formatUpTo`, `CardNumberInputFormatter`, `NoLeadingZeroFormatter`, `UFUInputBoxController.readText()`).

### 1.2 NOT exported by the main barrel → import explicitly

| Need | Import |
|---|---|
| `UFApiConfig` (HTTP client) | `package:universal_flutter_utils/api_config/api_config.dart` |
| `EncryptionUtil` | `package:universal_flutter_utils/api_config/encryption_util.dart` |
| `UFUListView` (paginated list/grid) | `package:universal_flutter_utils/widgets/listview/index.dart` |
| `UFUHtmlViewer` | `package:universal_flutter_utils/widgets/html/index.dart` |
| `UFUAddressModel` | `package:universal_flutter_utils/models/address.dart` |
| `UFULocalInfoModel` | `package:universal_flutter_utils/models/local_info.dart` |
| `UFULocalRepo` (IP geolocation) | `package:universal_flutter_utils/utils/local_information/repo.dart` |
| `FileHelper` | `package:universal_flutter_utils/utils/file_picker/file_helper.dart` |
| `FormValidator`, `DateTimeUtils` (use `UFUtils.*` wrappers instead) | `utils/form_validator/index.dart`, `utils/date_time/index.dart` |
| `ShowRecordingDialog` (use `UFUtils.picker.recordAudio()`) | `utils/file_picker/audio_file_handeling/index.dart` |
| `SocketInterceptor`, `SocketLoggingInterceptor` | `package:universal_flutter_utils/socket_config/interceptors/interceptor.dart` / `logging_interceptor.dart` |
| `Retry` | `package:universal_flutter_utils/api_config/interceptors/retry.dart` |
| `UFUAppConfig` | `package:universal_flutter_utils/utils/app_config/index.dart` |

---

## 2. App bootstrap (do this first)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- identity / endpoints ---
  UFUtils.appName        = 'My App';
  UFUtils.appVersion     = '1.0.0';
  UFUtils.baseUrl        = 'https://api.example.com/';   // trailing slash: requests are baseUrl + path
  UFUtils.socketBaseUrl  = 'https://socket.example.com/namespace';
  UFUtils.xPortal        = 'user';                       // sent as x-portal header (encrypted-header mode) / socket
  UFUtils.encryptionIV   = '16-char-iv-string';          // AES IV (16 chars) – default is a placeholder
  UFUtils.applyEncryption = false;                       // DEFAULT IS true — see §11.2
  UFUtils.fontFamily     = 'Roboto';                     // applied by UFUText / UFUInputBox

  // --- auth flow hooks ---
  UFUtils.startDestination   = '/login';                 // route used after session expiry / logout
  UFUtils.refreshDestination = '/splash';                // route used after refreshToken callback on 401
  UFUtils.refreshToken       = () async { /* call refresh API, store tokens */ };

  // --- brand colors (mutate the live palette) ---
  AppTheme.themeColors.primary   = const Color(0xff9381ff);
  AppTheme.themeColors.secondary = const Color(0xffb8b8ff);
  AppTheme.themeColors.tertiary  = const Color(0xffffd8be);
  UFUtils.buttonGradient = const LinearGradient(colors: [Color(0xff9381ff), Color(0xffb8b8ff)]);

  // --- optional ---
  await FileHelper.setLocalStoragePath();                // only if you use FileHelper.saveToTempDirectory etc.
  await UFUtils.firebaseUtils.initFirebase(options: DefaultFirebaseOptions.currentPlatform, notificationTap: (payload) {});
  UFUtils.firebaseUtils.initFCMToken();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => GetMaterialApp(   // REQUIRED
        title: UFUtils.appName,
        theme: ThemeData(useMaterial3: true),
        // translations: MyTranslations(),               // recommended — see §16
        home: const HomePage(),
      );
}
```

**Static configuration reference (`UFUtils`)**

| Field | Type / default | Meaning |
|---|---|---|
| `appName`, `appVersion` | String | Identity; `appVersion` goes to Crashlytics info |
| `baseUrl` | String (`"https://google.com"`) | Prefix for every `UFApiConfig` call |
| `socketBaseUrl` | String | Socket origin + optional namespace path |
| `fcmToken` | String | Filled by `initFCMToken()` |
| `applyEncryption` | bool (**true**) | AES body/header encryption switch |
| `encryptionIV` | String | AES-CBC IV (utf8, 16 chars) |
| `xPortal` | String `""` | `x-portal` header value |
| `startDestination` / `refreshDestination` | String | Named routes for session flows |
| `refreshToken` | `Function()?` | Called on 401 (§8.4) |
| `fontFamily` | String `""` | Font for UFUText/InputBox |
| `isRtl` | bool getter | From `Directionality` of `Get.context` |
| `buttonGradient` | Gradient | Used by `UFUButtonColorType.gradient` |
| `maxAllowedFileSize` | int 52428800 (50MB) | `FileHelper.checkIfLargeFile` |
| `singleAttachmentMaxSize` / `totalAttachmentMaxSize` | 10MB / 20MB | App-level limits (your code enforces) |
| `restrictFolderStructure` | bool true | App-level flag |
| `transitionDuration` | const 150 (ms) | Sheet/dialog animations |
| `ufuLoaderKey`, `ufuTokenExpireKey` | GlobalKey | Loader / expired-dialog visibility tracking |

---

## 3. "Use this instead of that" map

| You need | Use |
|---|---|
| Text | `UFUText` / `UFUTextSpan.getSpan` / `UFUReadMoreText` / `UFUHtmlViewer` |
| Button | `UFUButton`, `UFUTextButton`, `UFUIconButton` |
| Text field | `UFUInputBox` (+ `UFUInputBoxController`, `Debounce`) |
| OTP / PIN | `UFUOtpInputBox` |
| Checkbox | `UFUCheckbox` |
| Icon / SVG / network image | `UFUIcon`, `UFUSvgImage`, `UFUNetworkImage` |
| Scaffold with keyboard-dismiss | `UFUScaffold` |
| Loader dialog | `ShowUFULoader`, `UFUtils.hideLoaderDialog()` |
| Toast / snackbar | `UFUToast.showToast` |
| Confirmation / alert | `ShowUFUConfirmationDialog` / `UFUConfirmationDialog` |
| Bottom sheet (mobile) / dialog (tablet, desktop) | `ShowUFUBottomSheet`, `showUFUDialog`, `showUFUGeneralDialog` |
| Single choice list | `UFUSingleSelect` + `UFUSingleSelectModel` |
| Multi choice list | `UFUMultiSelect` + `UFUMultiSelectModel` |
| Grouped multi-select | `UFUMultiListMultiSelect` |
| Popup menu | `UFUPopUpMenuButton<T>` |
| Paginated list/grid + refresh + shimmer | `UFUListView` (+ `UFUShimmer`, `UFUNoDataFound`, `UFULoadMoreButton`) |
| Responsive layout | `UFUResponsiveBuilder`, `UFUScreen`, `UFUResponsiveDesign` |
| File/image/doc/audio/contact/date/time picking | `UFUtils.picker.*`, `UFUImagePicker.show`, `UFUFilePicker.show` |
| Image crop | `UFUImageCropper` |
| Video | `UFUVideoPlayer` |
| File tile / folder tile | `UFUThumb` |
| Map location picker / place autocomplete | `UFULocationPicker`, `UFUPlaceAutoComplete` |
| HTTP | `UFApiConfig` |
| Realtime | `UFSocketConfig` / `UFSocket` |
| Prefs / tokens | `UFUtils.preferences` (`UFPrefUtils`) |
| Permissions | `UFUtils.permissionUtils` |
| Firebase / FCM / local notifications | `UFUtils.firebaseUtils`, `UFNotificationUtils` |
| Social login | `UFUSocialLogin` |
| Biometrics | `UFUBiometricRecognition` |
| Validators | `UFUtils.*Validator` |
| Date/number/string helpers | `UFUtils.format*`, `parse*`, `timeAgo`, `addComasToNumber`, etc. |

---

## 4. Design tokens: theme, colors, typography

### 4.1 `AppTheme`
```dart
AppTheme.themeColors            // ThemeColors (mutable fields)
AppTheme.formUiHelper           // FormUiHelper
AppTheme.themeData              // ThemeModel(colors, formUiHelper)
AppTheme.setTheme(bool isDark)  // replaces palette with ThemeColors.dark()/light() (RESETS customizations – re-apply brand colors afterwards)
AppTheme.setThemeColors({Color? primary, secondary, tertiary, inverse, text, secondaryText, success, warning, dimGray, darkGray,
  lightBlue, purple, dimBlack, lightGrassGreen, grassGreen, lightFoam, foam, lightBrown, brown, lightWildBlue, wildBlue,
  lightYellow, yellow, lightRed, darkRed, lemon, darkYellow, mintGreen, oliveGreen, darkPurple, lightPurple, uranianBlue,
  gradientBlue, cornFlowerBlue, draft, lightestGray, dimRed, tealGreen, royalBlue, themeBlack, themeGreen, themeBlue,
  red, backgroundColor, selectedItemColor});   // bulk-set only the non-null ones
```

### 4.2 `ThemeColors` fields (light defaults)
`base`(white) · `primary`(themeBlue 0xff4779FF) · `lightPrimary` · `secondary`(themeBlack) · `secondaryLight` · `tertiary`(0xff54627D) · `inverse`(lightGray) · `text`(0xff222326) · `secondaryText`(gray) · `hintText`(gray) · `success` · `warning` · `dimGray` · `darkGray` · `lightBlue` · `purple` · `dimBlack` · `lightGrassGreen` · `grassGreen` · `lightFoam` · `foam` · `lightBrown` · `brown` · `lightWildBlue` · `wildBlue` · `lightYellow` · `yellow` · `lightRed` · `darkRed` · `lemon` · `darkYellow` · `mintGreen` · `oliveGreen` · `darkPurple` · `lightPurple` · `uranianBlue` · `cornFlowerBlue` · `gradientBlue` · `draft` · `lightestGray` · `dimRed` · `tealGreen` · `royalBlue` · `themeBlack` · `themeGreen` · `themeBlue` · `red` · `transparent` · `backgroundColor`(white) · `selectedItemColor`(uranianBlue).

`UFUColor` holds the raw constants (`UFUColor.white`, `.black`, `.gray`, `.lightGray`, `.transparent`, `.success`, `.warning`, `.red`, `.themeBlue`, `.primaryMaterialColor`, …).

### 4.3 `FormUiHelper` (spacing tokens)
`verticalPadding=20`, `horizontalPadding=16`, `inputVerticalSeparator=20`, `sectionSeparator=20`, `suffixPadding=12`, `sectionBorderRadius=18` → `AppTheme.formUiHelper.horizontalPadding`.

### 4.4 Typography enums
| `UFUTextSize` | px | | `UFUFontWeight` | weight |
|---|---|---|---|---|
| heading6 | 11 | | regular | w400 |
| heading5 | 12 | | medium | w500 |
| **heading4 (default)** | 14 | | semiBold | w600 |
| heading3 | 16 | | bold | w700 |
| heading2 | 18 | | | |
| heading1 | 20 | | | |
| size22 / 24 / 26 / 28 / 30 | 22–30 | | | |

`TextHelper.getTextSize(UFUTextSize)`, `TextHelper.getFontWeight(UFUFontWeight)` convert to raw values. Other enums: `UFUPosition {start,end}`, `UFUOrientation {horizontal,vertical}`, `UFUDuration {short(2s),medium(3s),long(4s)}`, `UFUFontFamily {productSans}`.

---

## 5. Widgets — basic

### 5.1 `UFUText`
```dart
UFUText(
  text: 'Hello',                      // required
  textSize: UFUTextSize.heading4,     // default heading4
  fontWeight: UFUFontWeight.regular,
  textColor: null,                    // default AppTheme.themeColors.text
  textAlign: TextAlign.center,        // NOTE default is center
  maxLine: null, overflow: null,
  textDecoration: null, decorationColor: null,
  letterSpacing: null, height: null,
  dynamicFontSize: null,              // overrides textSize with raw px
  isSelectable: false, fontStyle: FontStyle.normal,
)
```
Auto RTL direction. If `overflow` is set it inserts zero-width spaces between characters (non-Arabic, non-selectable) so long words wrap.

### 5.2 `UFUTextSpan.getSpan(text, {textSize, fontWeight, textColor, overflow, textAlign, maxLine, textDecoration, children, letterSpacing, recognizer, fontStyle, height}) → TextSpan`
For `Text.rich`/`RichText`.

### 5.3 `UFUButton`
```dart
UFUButton(
  text: 'Save',
  onPressed: () {}, onLongPress: null,
  colorType: UFUButtonColorType.primary,   // primary|tertiary|lightGray|lightBlue|secondary|secondaryLight|transparent|base|gradient
  type: UFUButtonType.solid,               // solid | outline
  size: UFUButtonSize.flat,                // flat(52, full width) large(52) medium(46) small(42) mediumWithIcon(38) extraSmall(26) smallIcon(26) floatingButton(62) datePickerButton(26) size24(24)
  buttonRadius: UFUButtonRadius.roundSquare, // circular(50) | roundSquare(12)
  radius: null,                            // custom radius for roundSquare
  width: null, isFlat: true,               // isFlat:true → size-based constraints; false → min width = screen/width
  disabled: false, isLoading: false,       // loading shows CupertinoActivityIndicator and blocks taps
  iconWidget: null, suffixIconWidget: null,
  textColor: null, bgColor: null, borderColor: null,
  gradient: null,                          // used when colorType == gradient (falls back to UFUtils.buttonGradient)
  opacity: 1,
  textSize: UFUTextSize.heading3, fontWeight: UFUFontWeight.bold,
)
```
Default `size: flat` is full-screen-width. For compact buttons use `small`/`medium`/`extraSmall`. Icon-only: pass `iconWidget` and omit `text`.

### 5.4 `UFUTextButton`
`UFUTextButton({text, onPressed, onLongPress, icon(IconData), iconPosition: UFUPosition.end, iconSize:16, color, fontWeight, textSize: heading3, textDecoration, decorationColor, highlightColor, padding:5, paddingInsets, isExpanded:false, isDisabled:false})`

### 5.5 `UFUIconButton`
`UFUIconButton({icon: Icons.add, iconSize:18, iconColor, backgroundColor (default lightBlue), borderRadius:8, highlightColor, iconWidget, onTap, onLongPress, isDisabled:false})`

### 5.6 `UFUIcon(IconData icon, {size, color, textDirection, weight})`

### 5.7 `UFUSvgImage({required assetPath, height, width, fit: BoxFit.none, colorFilter, isRtl})` — mirrors horizontally in RTL.

### 5.8 `UFUNetworkImage({src, size(UFUAvatarSize), boxFit: contain, height/width: double.maxFinite, borderRadius: 0, placeHolder})`
Cached (`cached_network_image`), sends `CookiesService.savedCookies` (CloudFront) as headers. Falls back to `placeHolder` or `assets/images/alt-image.png`.

### 5.9 `UFUAvatar({height, width, size: UFUAvatarSize?, radius:50, backgroundColor: transparent, borderColor, borderWidth, isDashedBorder, dashLength, child})`
`UFUAvatarSize`: `extraLarge`(128, fully round) `large`(42) `medium`(36 default) `small`(24) `size_72x72` `size_30x30`. Empty child shows a person icon.

### 5.10 `UFUDashedBorder` (a `Border` subclass for `BoxDecoration.border`)
`UFUDashedBorder.all({color, width, dashLength(required), strokeCap, spaceRatio, spaceLength, isOnlyCorner})`, `.fromBorderSide({side, dashLength})`, `.symmetric(...)`.

### 5.11 `UFUCheckbox`
`UFUCheckbox({selected:false, onTap: ValueChanged<bool>(currentValue), text, textSize, textColor, fontWeight, position: UFUPosition.start (checkbox before text), color, checkColor, uncheckColor, borderColor, height/width:17, padding, separatorWidth:8.5, disabled:false, isTextClickable:true})`
`onTap` receives the **current** value — toggle yourself: `onTap: (v) => setState(() => checked = !v)`. **`onTap` must be non-null.**

### 5.12 `UFUScaffold({appBar, body, drawer, bottomNavigationBar, bottomSheet, floatingActionButton(+Location), resizeToAvoidBottomInset: true, backgroundDecoration})`
Taps anywhere dismiss the keyboard. Default background is a dark-orange→primary vertical gradient; pass `backgroundDecoration: BoxDecoration(color: …)` to override.

### 5.13 `UFUReadMoreText(String text, {trimLines:3, trimLength:250, trimMode: TrimMode.line|length, trimCollapsedText:'read more', trimExpandedText:'less', showDialogOnReadMore:false, dialogTitle, dialogSubTitle, dialogDescriptionColor, textSize, fontWeight, textColor, trimCollapsedTextColor, trimExpandedTextColor, height, delimiter:'… ', callback(bool isCollapsed), textAlign, textDirection, semanticsLabel})`
Texts 250–500 chars expand inline (unless `showDialogOnReadMore`), longer texts open a dialog (`UFUReadDialog`).

### 5.14 `UFUHtmlViewer({data, ulColor, liColor, strongColor, emColor, insColor, insTextDecoration, pColor, spanColor})` (import path in §1.2)

### 5.15 Misc small widgets
- `UFUShimmer({height, width})` – rounded shimmer placeholder.
- `UFUNoDataFound({title, descriptions, icon, iconColor, iconSize, textColor, textSize})`.
- `UFULoadMoreButton({isLoadMore:false, callback})` (needs `load_more` translation key).
- `FadingCircle({color|itemBuilder, size:50, duration, controller})`, `SpinKitThreeBounce(...)` (spinners).
- `UFUPopUpMenuButton<T>({required itemList, required popUpMenuChild: (T)→Widget, popUpMenuButtonChild, onTap(T), offset, childPadding, toolTip})`.
- `UFUScaleInOutAnim({firstChildKey, firstChild, secondChild?, secondChildKey?, forward:true, duration})`, `UFUScaleAndRotateAnim({firstChildKey, secondChildKey, firstChild, secondChild, forward:true, duration})` – AnimatedSwitcher wrappers.
- `Animations.fromLeft/fromRight/fromTop/fromBottom/grow/shrink(animation, secondaryAnimation, child)` – transition builders for `Get.generalDialog`/`PageRouteBuilder`.

---

## 6. Inputs & forms

### 6.1 `UFUInputBox`
```dart
final c = UFUInputBoxController();            // optional, gives validate()/scrollAndFocus()/clear()/text
UFUInputBox(
  type: UFUInputBoxType.withLabel,            // see types below
  label: 'Email', hintText: 'you@mail.com',
  controller: textEditingController,          // plain TextEditingController (optional)
  inputBoxController: c,                      // UFU controller (optional)
  validator: (v) => UFUtils.emailValidator(v),
  onChanged: (v) {}, debounceTime: 500,       // ms; debounce applies to onChanged
  keyboardType: TextInputType.emailAddress,
  obscureText: false, readOnly: false, disabled: false, autofocus: false,
  maxLines: 1, maxLength: null, isCounterText: false, autoGrow: false,
  isRequired: true,                           // shows red * on label
  prefixChild: Icon(...), suffixChild: Icon(...), onTapSuffix: () {},
  inputFormatters: [NoLeadingZeroFormatter(), CardNumberInputFormatter()],
  fillColor, borderColor, borderRadius, textColor, hintFontColor, labelBgColor,
  textSize: UFUTextSize.heading4, hintTextSize, fontWeight, hintFontWeight,
  textAlign, textCapitalization: TextCapitalization.sentences, textInputAction,
  onFieldSubmitted, onSaved, onPressed (tap), onTapOutside, onTapUpOutside,
  padding, errorTextPadding, scrollController, scrollPadding, cursorWidth/Height, showCursor,
  chip / chipsList / moreChipsWidget,         // chips inside the field (first 5 + "more" widget)
  isExtWidget + extInputBoxController,        // phone "Ext" mini field
  avoidPrefixConstraints, prefixIconConstraints, enableSuggestions,
)
```
`UFUInputBoxType`: `withoutLabel` (default) · `withLabel` (floating label on border) · `withLabelOutside` (label above) · `withLabelAndClearIcon` · `searchbar` (search icon + clear) · `searchbarWithoutBorder` · `composeEmail` · `inline`.

Validation: inline red error text under the field (hidden for `searchbar`). Call `controller.validate()` (bool) to validate programmatically; `controller.scrollAndFocus()` scrolls the field into view and focuses.

**`UFUInputBoxController`**: `text` (get trimmed / set), `controller` (TextEditingController), `focusNode`, `key`, `validateOnChange`, `clear()`, `validate() → bool`, `scrollAndFocus()`, `setValidator(fn)`, `setParentController(...)`, `setParentFocusNode(...)`. Constructor `({String? text, bool validateInRealTime = false})`. Extension: `readText()`.

**`Debounce(Duration delay)`**: `debounce(() {...})`, `dispose()`.

### 6.2 `UFUOtpInputBox({inputBoxController, controller, focusNode, validator, onCompleted(String)})` — 56×56 numeric pinput boxes.

### 6.3 Validators (all return `String?`, null = valid)
```dart
UFUtils.emailValidator(v, {isRequired:true, field:'Email'})
UFUtils.passwordValidator(v, {isRequired:true, field:'Password'})   // 8–12 chars, upper, lower, digit, special
UFUtils.confirmPasswordValidator(v, {isRequired:true, required password})
UFUtils.phoneValidator(v, {isRequired:true, field:'Phone Number', phoneRegex})  // default ^\d{6,12}$, rejects all-zero
UFUtils.textValidator(v, {isRequired:true, minCount:3})
```
Formatters: `CardNumberInputFormatter()` (groups of 4), `NoLeadingZeroFormatter()` (digits only, no leading 0), `UFUtils.formatCardNumber(String)`.

---

## 7. Dialogs, sheets, feedback

### 7.1 Loader
```dart
ShowUFULoader(msg: 'Loading...');   // not awaited meaningfully; ignores if one already visible
... await work ...
UFUtils.hideLoaderDialog();        // or Get.back()
UFUtils.isLoaderVisible();
showUFUConfirmationLoader(show: isBusy, size: 20)  // returns SpinKitThreeBounce for button icons, or null
```
`UFULoader({text})` is the widget itself.

### 7.2 Toast
```dart
UFUToast.showToast('Saved', type: ToastType.success /*success|error|info|warning*/,
    title: null, backgroundColor, textColor, testSize: UFUTextSize.heading3, gravity: ToastGravity.TOP);
```
Throttled to one toast per second. On desktop width (> 900) shows a slide-in `WindowsToast` overlay bottom-right instead.

### 7.3 Confirmation dialog
```dart
final r = await ShowUFUConfirmationDialog(
  title: 'Delete?', subTitle: 'Cannot be undone.', subTitleColor: null,
  prefixBtnText: 'Cancel', suffixBtnText: 'Delete',       // suffix hidden when empty
  onTapPrefix: null /* default Navigator.pop */, onTapSuffix: () { Get.back(result: true); },
  icon: Icons.warning_amber_outlined, iconSize: 28, onTapIcon: null,
  type: UFUConfirmationDialogType.message,                 // message (2 buttons) | alert (1 button)
  content: Widget?, suffixBtnIcon: Widget?, disableButtons: false,
  buttonRadius: UFUButtonRadius?, prefixBtnColorType: UFUButtonColorType?,
);
```
Widget form: `UFUConfirmationDialog(...)` same params (use inside `ShowUFUBottomSheet`). Button labels are uppercased.
`UFUtils.showUnsavedChangesConfirmation({unsavedResourceId})` shows a ready-made "unsaved changes" sheet (uses `.tr` keys).

### 7.4 Bottom sheet / dialog family (adaptive)
```dart
final result = await ShowUFUBottomSheet(
  child: (UFUBottomSheetController c) => MyContent(),   // c.isLoading, c.toggleIsLoading(), c.switchValue, c.toggleSwitchValue(v)
  isScrollControlled: false, ignoreSafeArea: true, isDismissible: true, enableDrag: false,
  allowFullWidth: false, enableInsets: false,
);
```
- Mobile (`UFUScreen.isMobile`) → `Get.bottomSheet`; tablet/desktop → centered dialog 550 px wide.
- `showUFUDialog({child, allowFullWidth, enableInsets})` – always dialog.
- `showUFUGeneralDialog({child, secondChild, isDismissible, allowFullWidth})` – slide-from-bottom general dialog on mobile.
- All are no-ops when `RunModeService.isUnitTestMode`.
- Return value = what you pass to `Get.back(result: …)`.

`UFUCustomListBottomSheet({title, widgetList, isFilterSheet, canShowIconButton, iconButton*})` – styled container with header + arbitrary widgets.

---

## 8. Selection widgets

All selection widgets render **content only**; wrap in `ShowUFUBottomSheet` and close yourself.

### 8.1 Single select
```dart
final id = await ShowUFUBottomSheet(
  child: (_) => UFUSingleSelect(
    title: 'Select city',
    mainList: [UFUSingleSelectModel(id: '1', label: 'Delhi'), UFUSingleSelectModel(id: '2', label: 'Mumbai')],
    selectedItemId: '1',
    onItemSelect: (id) => Get.back(result: id),
  ),
);
```
`UFUSingleSelect` params: `mainList`(req), `selectedItemId`, `onItemSelect(String id)`, `title`, `isFilterSheet`, `inputHintText`, `canShowSearchBar` (auto: shown when list >10 and not filter sheet, or network), `type: UFUSingleSelectType.local|network`, `isLoading`, `isLoadMore`, `canShowLoadMore`, `onLoadMore`, `onSearch(String)` (network only; local filters by label), `listLoader`, `suffixButtonText/prefixButtonText` + `onTapSuffixBtn/onTapPrefixBtn`, `canShowIconButton` + `iconButtonIcon/Size/Color/BackgroundColor/BorderRadius/IconWidget` + `onIconButtonTap`, `showIncludeInactiveButton`.
`UFUSingleSelectModel({required label, required id, child, color, borderColor, borderWidth, suffix, onTapItem, additionalData, prefixLabel, subLabel:'', labelController, isEditable:false, active:true})`. An item with `id == "sub_title"` renders as a section header. Auto-scrolls to the selected item when list > 10.

### 8.2 Multi select
```dart
await ShowUFUBottomSheet(
  isScrollControlled: true,
  child: (_) => UFUMultiSelect(
    title: 'Select tags',
    mainList: items,                       // List<UFUMultiSelectModel>, set isSelect for preselected
    maxSelection: 5, onMaxSelectionReached: () => UFUToast.showToast('Max 5', type: ToastType.warning),
    onDone: (all) {                        // returns ALL items (local) – filter by isSelect
      final picked = all.where((e) => e.isSelect).toList();
      Get.back(result: picked);            // DONE DOES NOT CLOSE THE SHEET; CANCEL DOES
    },
  ),
);
```
`UFUMultiSelect` params: `mainList`(req), `onDone(List<UFUMultiSelectModel>)`, `title:'Select option'`, `inputHintText`, `isFilterSheet`, `doneIcon`, `disableButtons`, `canDisableDoneButton` (disable Done when none selected), `headerPrefixChild`, `helperText`, `totalAmount`+`updateTotalAmount`, `maxSelection`, `onMaxSelectionReached`, `hideSelectAll`, `onTapItem(list, index)`, `subList` + `canShowSubList` + `showSubList` + `subTitleHeader` (tag filter using `UFUMultiSelectModel.tags: List<TagLimitedModel>`), `showIncludeInactiveButton`, network mode: `type: UFUMultiSelectType.network`, `isLoading`, `isLoadMore`, `canShowLoadMore`, `onLoadMore`, `onSearch`, `totalNetworkListCount`, `listLoader`, `initialSelectionsForNetworkList`.
Search bar appears when `mainList.length > 8`. "Select all" is hidden when `maxSelection` is set.

`UFUMultiSelectModel({required label, required id, required isSelect, child, color, borderColor, prefixLabel, suffixLabel, subList, subListLength, tags, additionData, additionalDetails, displayLabelOnly:false, active:true, isDisabled:false, disableMessage, labelController})` (+ `clone`).
`UFUMultiSelectMultiListModel({label, list})` & `UFUMultiListMultiSelect({data, onDone(List<UFUMultiSelectMultiListModel>), title, searchHint})` for grouped lists (use `UFUMultiSelectMultiListModel.getSelectedItems(group)`).

### 8.3 Pop-up menu / action model
`PopoverActionModel({required label, required value, isSelected:false, isDisabled:false, icon})`, `PopoverActionModel.selectAction(list, value)`.

---

## 9. Lists, layout, responsive

### 9.1 `UFUListView` (import from `widgets/listview/index.dart`)
```dart
UFUListView(
  listCount: items.length,                // number of real items
  itemBuilder: (context, index) {
    if (index < items.length) return ItemTile(items[index]);
    // index == items.length  ⇒ footer slot (itemCount is listCount + 1)
    return canLoadMore ? Center(child: FadingCircle(color: AppTheme.themeColors.primary, size: 25))
                       : const SizedBox.shrink();
  },
  onRefresh: () async => await reload(),      // pull-to-refresh (omit to disable)
  onLoadMore: canLoadMore ? () async => await loadNext() : null, // fired near end
  isLoading: firstLoad,                       // true ⇒ shimmer placeholders (10 items)
  shimmerBuilder: (ctx, i) => const UFUShimmer(height: 80, width: double.maxFinite),
  noDataText: 'No results', noDataWidget: null,   // shown when listCount == 0
  isGridView: false, gridDelegate: null,      // default 2 columns, 10px spacing
  isReverse: false,                           // chat style; refresh by pulling at bottom
  scrollDirection: Axis.vertical, physics, scrollController, padding: EdgeInsets.zero,
  shrinkWrap: true, doAddFloatingButtonMargin: false, disableOnRefresh: false,
)
```
**Always handle `index == listCount` in `itemBuilder`** (the list renders one extra item).

### 9.2 Responsive
```dart
UFUResponsiveBuilder(mobile: A(), tablet: B(), desktop: C())   // fallbacks: tablet→mobile, desktop→tablet
UFUScreen.type / isMobile / isTablet / isDesktop / width / height / hasBottomPadding / orientation
UFUScreen.setDimensions(GlobalKey)        // measure a subtree and update width/height
DeviceType { mobile, tablet, desktop }    // breakpoints: >600 tablet, >900 desktop
UFUResponsiveDesign.minimumTabletWidth(600) / minimumDesktopWidth(900) / maxPopOverWidth(550) / maxButtonWidth(500) / floatingButtonSize(80) …
```
`UFULayoutBuilder` currently throws `UnimplementedError` in its constructor — **do not use**.

### 9.3 Thumbs (file / folder / image tiles)
```dart
UFUThumb(
  type: UFUThumbType.icon,                 // folder | image | icon
  iconType: UFUtils.getIconTypeAccordingToExtension(path), // UFUThumbIconType (pdf, doc, docx, xls, xlsx, csv, ppt, pptx, zip, rar, txt, json, png, jpg, jpeg, eml, ai, psd, eps, dxf, dwg, skp, …)
  fileName: 'report.pdf', userName: 'Sam', titleBottomText: 'Uploaded by',
  folderCount: '12', thumbImage: Image.network(...), statusTag: Widget, thumbIconList: [Icon...],
  isSelect: false, isDisabled: false, isQuickActionIconDisabled: false,
  onTap: (isSelected) {}, onLongPress: null, suffixTap: (isSelected) {}, suffixIcon: null,
)   // 163×163 tile; onTap and suffixTap must be provided
```
Also `UFUThumbIcon`, `UFUThumbFolder`, `UFUThumbImage`, `ThumbSize {small, large}`.

---

## 10. Media & pickers

### 10.1 `UFUtils.picker` (`UFFilePickerUtil`)
```dart
Future<String?>      selectDocument({List<String>? allowedExtensions})   // default pdf,doc,docx,png,jpg,jpeg → path
Future<List<XFile>>  selectImageFromGallery({bool selectMultiple=false}) // single is compressed (600px wide JPEG q85)
Future<List<XFile>>  captureImageFromCamera({bool selectMultiple=false}) // requests camera permission; [] if denied
Future<dynamic>      recordAudio()                                       // mic permission + waveform dialog → file path
Future<String?>      selectContacts()                                    // JSON string of ContactModel {fullName, phoneNumbers}
Future<DateTime?>    selectDate({DateTime? initialDate, DateTime? startDate, DateTime? endDate}) // see gotcha §17
Future<TimeOfDay?>   selectTime({TimeOfDay? initialTime})                // themed, AM/PM
Future<void>         permissionDeniedDialogue()                          // "Go to Settings" sheet
```
### 10.2 Ready-made source chooser sheets
```dart
String? path = await UFUImagePicker.show(bgColor: null);           // camera | gallery → path
String? path = await UFUFilePicker.show(allowedExtensions: ['pdf']); // camera | documents → path
UFUImagePicker.pickImageFromGallery() / pickImageFromCamera()
```
### 10.3 Cropper
```dart
final String? croppedPath = await Get.to(() => UFUImageCropper(
  imagePath: path,
  cropShape: UFUImageCropShape.circle,        // circle | square | ratio
  cropRatio: UFUImageCropRatio.ratio1x1,      // ratio1x1 | ratio16x7 | ratio5x3 (only used for shape ratio)
));
```
### 10.4 Video
```dart
Get.to(() => const UFUVideoPlayer(), arguments: {'video_url': 'https://…/a.mp4'});
```
Locks to landscape while open and restores portrait on dispose. `video_url` argument is mandatory.

### 10.5 Maps / location
```dart
// Full-screen picker; returns UFUAddressModel via Get.back(result)
final UFUAddressModel? addr = await Get.to(() => UFULocationPicker(apiKey: gmapsKey, address: existing, backButton: BackButton(), placesAPIHeader: null));

// Inline autocomplete field
UFUPlaceAutoComplete(
  apiKey: gmapsKey, searchHintText: 'Search address',
  textController: UFUInputBoxController(),
  onDecodeAddress: (UFUAddressModel? a) {},   // fired when user picks a suggestion
  onTextChange: (s) {}, borderColor, textSize, fontWeight,
  prefixIcon, suffixIcon, trailing, backButton, showClearButton: true, address, placesAPIHeader,
)

LatLng? here = await UFUtils.fetchCurrentLocation();   // handles permission + GPS-service prompts (returns null on failure)
UFUtils.launchMapIntent(UFUAddressModel? address);      // opens Apple Maps / geo: / Google link
UFUtils.openAppSetting(); UFUtils.openLocationSetting();
```
Underlying configurable widgets exported: `UFUPlacePicker` (map + search, ~100 params mirroring map_location_picker) and `CustomPlaceAutoComplete`.
`UFUAddressModel` fields: `id, address, address1, address2, completeAddress, city, state, country, postcode, latitude, longitude, placeId, userId, createdAt, updatedAt` + `fromJson/toJson` (snake_case: `complete_address`, `place_id`…), `copyWith`, `getFormatedAddress()`.
Required platform config: Google Maps API keys (AndroidManifest / AppDelegate / web index.html).

---

## 11. Networking — `UFApiConfig`

```dart
import 'package:universal_flutter_utils/api_config/api_config.dart';
final api = UFApiConfig();      // new Dio each time, baseUrl=UFUtils.baseUrl, connect/receive timeout 10s
```
| Method | Signature | Notes |
|---|---|---|
| `get` | `get(path, {queryParameters, infiniteTimeout=false, header})` | URL = `baseUrl + path`; params not encrypted |
| `post` | `post(path, {data, infiniteTimeout, overrideBody=false, header, queryParameters})` | body encrypted when `applyEncryption` (unless `overrideBody:true` → plain JSON string) |
| `put`, `patch` | same as `post` | |
| `delete` | `delete(path, {data})` | no header/query support |
| `uploadFile` | `({required path, required File file, required fileParam, Map<String,dynamic>? data}) → Map?` | multipart, bearer token from prefs, skips interceptor |
| `uploadMultiFile` | `({required path, required List<File> files, required fileParam, data})` | same |
| `downloadFile` | `({required url, onProgress(double percent)}) → String path` | Android: `/storage/emulated/0/Download/myApp/`; others: app documents `/myApp/` |

All return `response.data` (decoded JSON) and **rethrow** `DioException` (after the interceptors have already shown a toast).
`header:` replaces **all** headers for that call (Authorization is NOT added automatically in that case).

```dart
final data = await UFApiConfig().post('auth/login', data: {'username': u, 'password': p});
await UFUtils.preferences.writeString(UFUtils.preferences.authToken, data['accessToken']);
final me = await UFApiConfig().get('auth/me');
```

### 11.1 Interceptors (automatic)
1. **RequestInterceptor** – (non-web) DNS-lookups `google.com`; no internet → rejects with `connectionError`. Then headers: `skipInterceptor` extra → untouched; custom `header` extra → used as-is; else builds headers from stored auth token (falls back to refresh token) and selected-language JSON (`readSelectedLanguage()`), via `EncryptionUtil.secKeyEncryptWithHeaderAppKey`.
2. **ResponseInterceptor** – logs only.
3. **ErrorInterceptor** – maps error → toast (`UFUToast`, type error) using translation keys; hides loader; on **401**: if `UFUtils.refreshToken != null` → runs it after 4 s (throttled `Retry.execute`) then `Get.offAndToNamed(refreshDestination)` (if set); else clears prefs (keeps `rememberMeData`), sets `isLoggedOut=true`, shows a non-dismissible session-expired sheet routing to `startDestination` (or "account blocked" message when the server message contains "blocked").
`UFUtils.handleError(Object e)`: use in your own `catch` — ignores DioException toasts (already shown), runs refresh on 401, logs non-Dio errors to Crashlytics with user id/route/app version.

### 11.2 Encryption (`EncryptionUtil`)
Scheme: random 32-byte AES key per call, AES-CBC with `UFUtils.encryptionIV`; body becomes `{"sek": <hex cipher>, "hash": <hex key>}`; encrypted headers become `{sek, hash, deviceType:'android'}` of the JSON `{date, x-portal, authorization:"Bearer …", …lang}`. Helpers: `secKeyEncryptWithBodyAppKey(map)`, `secKeyEncryptWithHeaderAppKey(auth, extra)`, `secKeyDecryptedWithSek({sek, hash})`, `hexStringToByteArray`.
**Your backend must implement this scheme. For a normal REST backend set `UFUtils.applyEncryption = false`** (then headers are plain `{date, x-portal, authorization: Bearer …}` and bodies are plain JSON).

### 11.3 Misc
`Retry.execute(callback, {delay})` / `Retry.cancel()` – 1 s cooldown + optional delay. `CookiesService.setAndModifyCloudFrontCookies(String setCookieHeader)` / `CookiesService.savedCookies`. `UFULocalRepo().getLocal()` → `UFULocalInfoModel` (ip-api.com: country, city, lat, lon, timezone, isp…).

---

## 12. Realtime — `UFSocketConfig` / `UFSocket`

```dart
final socket = await UFSocketConfig.initializeSocket(
  initListeners: ({required socket, required on}) {
    on('message', (data) => print(data));
  },
);                                                  // connects using UFUtils.socketBaseUrl + stored auth token (20s timeout)
UFSocketConfig.send('chat', {'text': 'hi'});        // emit
UFSocketConfig.on('typing', (d) {});               // listen
socket.emit(event: 'x', data: {...}, onResponse: (ack) {}, onError: (e) {});
socket.listen(event: 'x', onData: (d) {}, onError: (e) {}) → Stream;   socket.off('x');
socket.isConnected; socket.disconnect(); socket.dispose();
UFSocketConfig.interceptors.add(MySocketInterceptor());   // onSend/onReceive/onError; SocketLoggingInterceptor auto-attached
```
Transport is Engine.IO v4 **HTTP long-polling** (custom client) with `Authorization: Bearer <token>` and `x-portal`; namespace is taken from the path of `socketBaseUrl`. Auto re-handshake after errors.

---

## 13. Storage, permissions, device utilities

### 13.1 `UFUtils.preferences` (`UFPrefUtils`)
Keys (fields): `isFirstRun, isLoggedIn, isLoggedOut, authToken, refreshToken, selectedLanguage, rememberMeData, userData, skippedAppVersion, notificationPayload`.
Methods: `writeString/readString`, `writeBoolean/readBoolean`, `writeObject/readObject`, `readAuthToken()`, `readRefreshToken()` (+ typo alias `readRefereshToken`), `readSelectedLanguage()`, `readIsUserLoggedIn()`, `readIsFirstRun()` (default true), `clearAuthToken()`, `clearPref()` (all except `rememberMeData`), `clearPrefExcept({keysToKeep})`, `getStorage()`.
Store tokens: `UFUtils.preferences.writeString(UFUtils.preferences.authToken, token)`.

### 13.2 `UFUtils.permissionUtils` (`UFPermissionUtils`) → all `Future<bool>`
`getAllPermissions, getStoragePermission, getCameraPermission, getPhotosPermission, getNotificationsPermission, getLocationPermission, getContactsPermission (+ getContactPermissions), getAudioPermission, getMicrophonePermission, getVideosPermission`. You still must declare platform permissions (AndroidManifest / Info.plist).

### 13.3 Firebase / notifications
```dart
await UFUtils.firebaseUtils.initFirebase(options: DefaultFirebaseOptions.currentPlatform, notificationTap: (Map<String,dynamic> payload) {...});
UFUtils.firebaseUtils.initFCMToken();           // fills UFUtils.fcmToken, listens for refresh
String? t = await UFUtils.firebaseUtils.getFCMToken();
UFNotificationUtils.requestNotificationPermission();
```
`initFirebase` also initializes `flutter_local_notifications` (Android/iOS/macOS/Linux/Windows), shows foreground FCM messages locally (channel `high_importance_channel`), stores last payload in prefs (`notificationPayload`), calls `notificationTap` on tap. FCM is skipped on Windows/Linux.

### 13.4 Auth helpers
```dart
final s = UFUSocialLogin();
UserCredential? g = await s.signInWithGoogle(clientId: serverClientId);       // null on failure
Map<String,dynamic>? a = await s.signInWithApple(clientId: servicesId);       // {displayName, user: UserCredential}
Map<String,dynamic>? f = await s.signInWithFacebook(1 /*socialType*/);        // {socialId,email,fullName,image,socialType}
final bio = UFUBiometricRecognition();
if (await bio.isBiometricSupported()) { final ok = await bio.validateBiometric(); }
```
Firebase must be initialized first for Google/Apple.

### 13.5 `FileHelper` (import §1.2)
`setLocalStoragePath()` (call once), `openLocalFile(path,{type})`, `checkFileExist`, `saveFile(path, bytes)`, `saveBase64File(bytes, name)`, `getFileName`, `getFileExtension` (only returns extensions in `FileUploadSupportedFiles.extensions`), `readFileAsByte/String`, `getFileSizeWithUnit(bytes)`, `checkIfImage`, `getTempDirPath`, `filterFilePath`, `saveToTempDirectory(paths,{doShowLoader})`, `getUniqueFileName`, `deleteFile`, `checkIfLargeFile(path)` (vs `maxAllowedFileSize`), `getClassType(mime)`, `checkIsUnsupportedFile(name, 'open'|'print')`, `isUnsupportedViewFile`, `isUnsupportedPrintFile`.

### 13.6 Other `UFUtils` helpers
| Group | API |
|---|---|
| Date/time | `formatDate(dt,{format:'dd/MM/yyyy'})`, `formatTime(dt,{'hh:mm a'})`, `formatCompleteDateTime`, `parseDate`, `parseTime`, `parseCompleteDateTime`, `timeOfDayToDateTime(TimeOfDay)`, `timeAgo(dt)`, `dayWishes()` |
| Numbers/strings | `addComasToNumber(String?)`, `formatCardNumber`, `isTrue(dynamic)`, `isTrueReverse(bool?)→int`, `isValueNullOrEmpty`, `isInvalidValue(v,{shouldNotZero})`, `getEmailTo`, `convertEmailListToStringList`, `encodeToHTMLString(map)`, `String.capitalize()`, `String.formatUpTo({maxDecimalPoints:2}) → double` |
| HTML | `parseHtmlToText(html)`, `parseHtmlString(html)` |
| Collections | `groupBy<S,T>(values, keyFn) → Map<T,List<S>>` |
| Clipboard / share | `copyToClipBoard(text)`, `launchShareIntent(message)` |
| Launchers | `launchUrl(url,{isInExternalMode:true})`, `launchCall(phone)`, `launchSms(phone)`, `launchEmail(email,{subject})`, `launchMapIntent(address)` |
| UI helpers | `hideKeyboard()`, `showKeyboard()`, `shouldApplySafeArea(context)`, `addArguments(map)`, `isLoaderVisible()`, `isTokenExpiredVisible()` |
| File type | `getIconTypeAccordingToExtension(path,{extensionName}) → UFUThumbIconType` |
| Legacy DB | `getOldAppDBPath(name)` |

Constants: `PaginationConstants.pageLimit(20) / pageLimit10 / pageLimit50 / pageLimit250 / noLimit(0)`; `FileUploadStatus {pending, uploading, paused, uploaded}`; `FileUploadType.*`; `FileUploadSupportedFiles.extensions`; `SrsSupportedFiles.extensions`.
Server-driven select params: `UFUNetworkMultiSelectParams({page:1, limit:20, keyword:''})`, `UFUNetworkMultiSelectType {get, post}`.
Testing: `RunModeService.setRunMode(RunMode.unitTesting)` suppresses sheets/dialogs.

---

## 14. Platform prerequisites (what the host app must configure)
- **Firebase**: `google-services.json` / `GoogleService-Info.plist` / `firebase_options.dart` for FCM, Auth, Crashlytics.
- **Permissions**: camera, photos, microphone, contacts, location, notifications, storage in AndroidManifest / Info.plist (matching the helpers you call).
- **Google Maps**: API key per platform; Places & Geocoding APIs enabled.
- **Sign-in**: Google serverClientId, Apple Sign-In capability, Facebook app id/client token.
- **Assets**: `UFUNetworkImage` fallback uses `assets/images/alt-image.png` — declare it in your app (see §17).
- **Translations**: provide GetX translations for keys in §16.

---

## 15. Recipes (end-to-end, package-only)

**Login screen**
```dart
class LoginController extends GetxController {
  final email = UFUInputBoxController(), pass = UFUInputBoxController();
  Future<void> login() async {
    if (!(email.validate() & pass.validate())) return;
    ShowUFULoader(msg: 'Signing in...');
    try {
      final r = await UFApiConfig().post('auth/login', data: {'email': email.text, 'password': pass.text});
      await UFUtils.preferences.writeString(UFUtils.preferences.authToken, r['token']);
      UFUtils.hideLoaderDialog();
      Get.offAllNamed('/home');
    } catch (e) { UFUtils.hideLoaderDialog(); UFUtils.handleError(e); }
  }
}
// UI
UFUScaffold(
  backgroundDecoration: BoxDecoration(color: AppTheme.themeColors.base),
  body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
    UFUInputBox(type: UFUInputBoxType.withLabel, label: 'Email', inputBoxController: c.email, validator: (v) => UFUtils.emailValidator(v)),
    const SizedBox(height: 16),
    UFUInputBox(type: UFUInputBoxType.withLabel, label: 'Password', obscureText: true, inputBoxController: c.pass, validator: (v) => UFUtils.passwordValidator(v)),
    const SizedBox(height: 24),
    UFUButton(text: 'LOGIN', onPressed: c.login),
  ])),
)
```
**Paginated list** — see §9.1 and the controller pattern: keep `items`, `page`, `canLoadMore`; `onRefresh` resets page; `onLoadMore` fetches `page+1` with `PaginationConstants.pageLimit`.
**Avatar upload** — `UFUImagePicker.show()` → `Get.to(UFUImageCropper(...))` → `UFApiConfig().uploadFile(path:'users/avatar', file: File(p), fileParam:'file')`.
**Delete confirmation** — `final ok = await ShowUFUConfirmationDialog(title:'Delete?', suffixBtnText:'Delete', onTapSuffix: () => Get.back(result: true));`

---

## 16. Required translation keys (GetX `.tr`)
The package calls `.tr` with these snake_case keys; without translations GetX shows the **key itself**. Provide them (English at minimum):
`an_error_occurred, something_went_wrong_try_again, something_went_wrong, request_timed_out, it_seems_server_is_taking_too_long, unauthorized_access, no_internet_connection, server_error, your_session_has_expired_please_login_again, account_blocked, ok, login, unsaved_changes, unsaved_changes_desc, dont_save, cancel, is_required, enter_valid_phone_number, this_field_is_required, must_be_at_least, characters, preparing_files, unsupported_file_for_download_view, unsupported_file_for_print, load_more, items, search_here, confirm_location`.

---

## 17. Known gotchas (verified in source)
1. **`GetMaterialApp` is mandatory**; `Get.context` null before first frame → don't show dialogs/toasts in `main()`.
2. **`UFApiConfig`, `UFUListView`, `UFUAddressModel`, `FileHelper`, `UFUHtmlViewer` are not in the barrel** (§1.2).
3. **`applyEncryption` defaults to `true`** and replaces request headers with `{sek, hash, deviceType}`; against a normal API set it to `false`.
4. `RequestInterceptor` resolves `google.com` before each request (non-web); offline-only/ firewalled networks will be treated as "no internet".
5. `UFUListView` item count is `listCount + 1` → guard `index == listCount`.
6. `UFUMultiSelect.onDone` does **not** close the sheet and returns the whole cloned list (check `isSelect`).
7. `UFUCheckbox.onTap` receives the old value; you must flip state.
8. `UFUtils.picker.selectDate` is birth-date oriented: `firstDate = now − 90y`, `lastDate = startDate ?? now − 8y`; `endDate` is unused. For arbitrary dates call `showDatePicker` yourself or pass a suitable `startDate` (it becomes the **last** selectable date).
9. `FileHelper.checkIfImage/checkIfImagePhotosDocument/getClassType` contain mangled literals (`'UFUg'`, `'UFUeg'`) — JPG/JPEG are **not** detected (only png, jfif, webp). Use your own extension check for jpg.
10. Asset paths: `UFUThumbFolder` / `UFUThumbImage` reference `package: 'UFU_mobile_flutter_ui'` and `UFUNetworkImage` uses an un-prefixed `assets/images/alt-image.png`; in a consuming app these may fail to resolve → pass `placeHolder`/`thumbImage` explicitly or copy the asset.
11. `UFUVideoPlayer` throws if `Get.arguments["video_url"]` missing; forces landscape.
12. `UFULayoutBuilder` throws `UnimplementedError`. `UFUScreen.width/height/type` are computed once at startup — call `UFUScreen.setDimensions(key)` or update `UFUScreen.type` yourself on rotation/resize.
13. `AppTheme.setTheme(true)` swaps to a dark palette but dark `text` is still near-black and `backgroundColor` white; set the colors you need after toggling (`setTheme` also discards earlier customizations).
14. `UFUText` default `textAlign` is **center**; pass `TextAlign.start` for left-aligned paragraphs.
15. `UFUButton` default size `flat` stretches to the full screen width.
16. `UFApiConfig.uploadFile/uploadMultiFile` hardcode header `x-portal: user`; `downloadFile` writes into a `myApp` sub-folder.
17. Socket uses long-polling only (no WebSocket) and only `socket_config.dart` is exported, so interceptor base classes need direct imports.
18. `UFUtils.handleError` for 401 only acts if `refreshToken` is set; otherwise the ErrorInterceptor already showed the expired-session sheet.
19. `ShowUFULoader` returns immediately (not awaitable for completion) and is single-instance.
20. `UFUtils.getIconTypeAccordingToExtension` falls back to `pdf` icon for unknown extensions.

---

## 18. Package layout (for navigation)
```
lib/
 universal_flutter_utils.dart   barrel
 api_config/                    UFApiConfig, EncryptionUtil, interceptors/{request,response,error,retry}
 common/                        UFUColor, enums, text helpers, constants/{screen,responsive_design,pagination,file_uploder}, services/{cookies,firebase,notification,run_mode,social_login}
 extensions/                    String ext, CardNumberInputFormatter, NoLeadingZeroFormatter, input-box ext
 models/                        UFUAddressModel, ContactModel, UFULocalInfoModel, PopoverActionModel, UFUNetworkMultiSelectParams
 socket_config/                 UFSocket, UFSocketConfig, interceptors
 theme/                         AppTheme, ThemeColors, FormUiHelper, ThemeModel
 utils/                         UFUtils hub + app_config, date_time, direction_helper, file_picker(+file_helper,+audio), form_validator, local_information, map_launcher, permissions, shared_preferences, biometric_recognition
 widgets/                       ~45 UI components (see §5–§10)
example/                        reference app: widgets, API calls, file picker samples
```
