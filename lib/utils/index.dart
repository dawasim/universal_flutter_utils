import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart' as ul;
import 'package:universal_flutter_utils/universal_flutter_utils.dart';
import 'package:universal_flutter_utils/utils/app_config/index.dart';
import 'package:universal_flutter_utils/utils/file_picker/file_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/methods/index.dart';
import 'date_time/index.dart';
import 'file_picker/index.dart';
import 'form_validator/index.dart';
import 'permissions/index.dart';
import 'shared_preferences/index.dart';

class UFUtils {
  static String appName = UFUAppConfig.appName;
  static String baseUrl = UFUAppConfig.baseUrl;
  static String socketBaseUrl = UFUAppConfig.socketBaseUrl;

  static GlobalKey<UFUConfirmationDialogState> ufuLoaderKey = GlobalKey<UFUConfirmationDialogState>();

  ///   Form Validations
  static String? emailValidator(String? value, {bool isRequired = true}) => FormValidator.emailValidator(value, isRequired: isRequired);
  static String? passwordValidator(String? value, {bool isRequired = true}) => FormValidator.passwordValidator(value, isRequired: isRequired);
  static String? phoneValidator(String? value, {bool isRequired = true}) => FormValidator.phoneValidator(value, isRequired: isRequired);
  static String? textValidator(String? value, {bool isRequired = true}) => FormValidator.textValidator(value, isRequired: isRequired);

  ///   Date-Time Formatting
  static String? formatDate(DateTime dateTime, {String format = 'dd/MM/yyy'}) => DateTimeUtils.formatDate(dateTime, format: format);
  static String? formatTime(DateTime dateTime, {String format = 'hh:mm a'}) => DateTimeUtils.formatTime(dateTime, format: format);
  static String? formatCompleteDateTime(DateTime dateTime, {String format = 'dd/MM/yyy hh:mm a'}) => DateTimeUtils.formatCompleteDateTime(dateTime, format: format);
  static String? timeAgo(DateTime dateTime) => DateTimeUtils.timeAgo(dateTime);
  static String? dayWishes() => DateTimeUtils.dayWishes();
  static DateTime? parseDate(String dateString, {String format = 'dd/MM/yyy'}) => DateTimeUtils.parseDate(dateString, format: format);
  static DateTime? parseTime(String timeString, {String format = 'hh:mm a'}) => DateTimeUtils.parseTime(timeString, format: format);
  static DateTime? parseCompleteDateTime(String completeDateTimeString, {String format = 'dd/MM/yyy hh:mm a'}) => DateTimeUtils.parseCompleteDateTime(completeDateTimeString, format: format);
  static DateTime? timeOfDayToDateTime(TimeOfDay time){
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }


  ///   Permission Handling
  static UFPermissionUtils permissionUtils = UFPermissionUtils();

  ///   Shared Preferences Handling
  static UFPrefUtils preferences = UFPrefUtils();

  ///   Storage Max File Size
  static int maxAllowedFileSize = 52428800; // Size is in bytes
  static int singleAttachmentMaxSize = 10 * 1024 * 1024; // 10MB
  static int totalAttachmentMaxSize = 20 * 1024 * 1024; // 20MB
  static bool restrictFolderStructure = true;

  ///   Animation Transition Duration
  static const int transitionDuration = 150;

  ///   File picker methods can be accessed using [picker] object
  static UFFilePickerUtil picker = UFFilePickerUtil();

  ///   All common methods can be accessed using [commonMethods] object
  static UFUCommonMethods commonMethods = UFUCommonMethods();

  static bool isLoaderVisible() => ufuLoaderKey.currentContext != null;

  //Add additional arguments to existing arguments
  static void addArguments(Map<String,int> args){
    if(Get.arguments != null){
      (Get.arguments as Map<String,int>).addAll(args);
    }
  }

  static Map<T, List<S>> groupBy<S, T>(Iterable<S> values, T Function(S) key) {
    var map = <T, List<S>>{};
    for (var element in values) {
      (map[key(element)] ??= []).add(element);
    }
    return map;
  }

  static bool shouldApplySafeArea(BuildContext context) {
    EdgeInsets viewPadding = MediaQuery.of(context).viewPadding;

    return viewPadding.bottom > 0;
  }

  // copyToClipBoard can be used to copy text to clipboard
  static Future<void> copyToClipBoard(String text) async {
    await Clipboard.setData(
      ClipboardData(text: text),
    );
  }

  // parseHtmlToText with HTML string as input and will return text from it
  static String parseHtmlToText(String html) {

    RegExp exp = RegExp(r"<.*?>", caseSensitive: false);
    final exp2 = RegExp(r"\n\s+");
    return html
        .replaceAll(exp, '')
        .replaceAll(exp2, '\n')
        .replaceAll('/<p[^>]*><\\/p[^>]*>/','')
        .replaceAll("<a.*?</a>", "")
        .replaceAll('&lt;','')
        .replaceAll('&nbsp;', ' ')
        .trim();
  }

  static bool isTrue(dynamic value){
    if (value == "1" || value == 1 || value == "true" || value == true) {
      return true;
    }
    return false;
  }

  static List<String> convertEmailListToStringList(List<dynamic>? models, {bool? isAlreadyString}) {
    List<String> emailList = [];

    if (isAlreadyString != null && isAlreadyString) {
      if (models != null) {
        for (var model in models) {
          String email = model.toString();
          emailList.add(email);
        }
      }
      return emailList;
    }

    if (models != null) {
      for (var model in models) {
        String email = model.email.toString();
        emailList.add(email);
      }
    }

    return emailList;
  }

  static int isTrueReverse(bool? value){
    if (value ?? false) return 1;
    return 0;
  }

  static String parseHtmlString(String htmlString) {
    htmlString = '<div>$htmlString</div>';
    var document = parse(htmlString);
    String parsedString = parse(document.body!.text).documentElement!.text;
    parsedString.replaceAll('/<p[^>]*><\\/p[^>]*>/','');
    return parseHtmlToText(parsedString);
  }

  static String getEmailTo(String val) {
    if (val.isNotEmpty) {
      int index = val.indexOf('@');
      if (index > -1) {
        final exp = RegExp('/[-_.]+/g');

        return val.substring(0, index).replaceAll(exp, "");
      }
    }
    return val;
  }

  // showUnsavedChangesConfirmation(): displays confirmation dialog
  static void showUnsavedChangesConfirmation({int? unsavedResourceId}) {
    UFUtils.hideKeyboard();
    ShowUFUBottomSheet(
      child: (_) => UFUConfirmationDialog(
        title: 'unsaved_changes'.tr,
        subTitle: 'unsaved_changes_desc'.tr,
        icon: Icons.warning_amber_outlined,
        suffixBtnText: 'dont_save'.tr.toUpperCase(),
        prefixBtnText: 'cancel'.tr.toUpperCase(),
        onTapSuffix: () async{
          // if(unsavedResourceId != null) await UnsavedResourcesHelper.deleteUnsavedResource(id: unsavedResourceId);
          Get.back();
          await Future<void>.delayed(const Duration(milliseconds: 200));
          Get.back(result: unsavedResourceId);
        },
      ),
    );
  }

  static UFUThumbIconType getIconTypeAccordingToExtension(String filePath, { String? extensionName }) {
    String ext = extensionName ?? FileHelper.getFileExtension(filePath) ?? '';

    switch (ext) {
      case 'png':
        return UFUThumbIconType.png;
      case 'pdf':
        return UFUThumbIconType.pdf;
      case 'xls':
        return UFUThumbIconType.xls;
      case 'xlsx':
        return UFUThumbIconType.xlsx;
      case 'txt':
        return UFUThumbIconType.txt;
      case 'docx':
        return UFUThumbIconType.docx;
      case 'xlsm':
        return UFUThumbIconType.xlsm;
      case 'doc':
        return UFUThumbIconType.doc;
      case 'csv':
        return UFUThumbIconType.csv;
      case 'ppt':
        return UFUThumbIconType.ppt;
      case 'pptx':
        return UFUThumbIconType.pptx;
      case 'zip':
        return UFUThumbIconType.zip;
      case 'rar':
        return UFUThumbIconType.rar;
      case 'eml':
        return UFUThumbIconType.eml;
      case 'ai':
        return UFUThumbIconType.ai;
      case 'psd':
        return UFUThumbIconType.psd;
      case 've':
        return UFUThumbIconType.ve;
      case 'eps':
        return UFUThumbIconType.eps;
      case 'dxf':
        return UFUThumbIconType.dxf;
      case 'skp':
        return UFUThumbIconType.skp;
      case 'ac5':
        return UFUThumbIconType.ac5;
      case 'ac6':
        return UFUThumbIconType.ac6;
      case 'sdr':
        return UFUThumbIconType.sdr;
      case 'json':
        return UFUThumbIconType.json;
      case 'pages':
        return UFUThumbIconType.pages;
      case 'numbers':
        return UFUThumbIconType.numbers;
      case 'dwg':
        return UFUThumbIconType.dwg;
      case 'esx':
        return UFUThumbIconType.esx;
      case 'sfz':
        return UFUThumbIconType.sfz;
      case 'url':
        return UFUThumbIconType.url;
      case 'UFUg':
        return UFUThumbIconType.UFUg;
      case 'UFUeg':
        return UFUThumbIconType.UFUeg;
      case 'hover':
        return UFUThumbIconType.hover;
      case 'eagle_view':
        return UFUThumbIconType.eagleView;

      default:
        return UFUThumbIconType.pdf;
    }
  }

  static hideKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

  static showKeyboard() => FocusManager.instance.primaryFocus?.requestFocus();

  static launchUrl(String url, {bool isInExternalMode = true}) async => await ul.launchUrl(Uri.parse(url), mode: isInExternalMode ? LaunchMode.externalApplication : LaunchMode.platformDefault);

  static launchCall(String phoneNumber) async => await ul.launchUrl(Uri.parse("tel://$phoneNumber"));

  static launchSms(String phoneNumber) async => await ul.launchUrl(Uri.parse("sms:$phoneNumber"));

  static launchEmail(String email, {String subject = ''}) async => await launchUrl("mailto:$email?subject=$subject");

  static void handleError(Object e) {
    if(e is DioException && e.type == DioExceptionType.cancel) {
      debugPrint('API REQUEST CANCELLED');
      return;
    } else {
      throw e;
    }
  }

  static Future<bool> openAppSetting() async => await Geolocator.openAppSettings();

  static openLocationSetting() => Geolocator.openLocationSettings();

  static bool isValueNullOrEmpty(dynamic value) {
    bool canCheckEmptiness = (value is String || value is List);
    return (value == null || (canCheckEmptiness && value.isEmpty) || value == 'null');
  }

  static bool isInvalidValue(dynamic val, {bool shouldNotZero = false}) {
    final actualValue = num.tryParse(val.toString()) ?? 0;
    bool isZero = false;
    if (shouldNotZero) isZero = actualValue == 0 || !actualValue.isFinite;
    return (val.toString() == '.') || isZero;
  }

  /// [encodeToHTMLString] - takes json as input and replaces special
  static String encodeToHTMLString(Map<String, dynamic> json) {
    return jsonEncode(json).replaceAll('"', "&quot;");
  }

  static Future<String> getOldAppDBPath(String dataBaseName) async {
    Directory? appLibraryDirectory;
    if (Platform.isAndroid) {
      appLibraryDirectory = await getApplicationDocumentsDirectory();
      return '${appLibraryDirectory.path.replaceFirst("/app_flutter", "")}/databases/$dataBaseName';
    } else {
      appLibraryDirectory = await getLibraryDirectory();
      return "${appLibraryDirectory.path}/LocalDatabase/$dataBaseName";
    }
  }
}