import 'package:intl/intl.dart';

class DateTimeUtils {
  // Format DateTime to a readable string
  static String formatDate(DateTime dateTime, {String format = 'yyyy-MM-dd'}) {
    return DateFormat(format).format(dateTime);
  }

  // Format TimeOfDay to a readable string
  static String formatTime(DateTime dateTime, {String format = 'hh:mm a'}) {
    return DateFormat(format).format(dateTime);
  }

  // Format complete DateTime to a readable string
  static String formatCompleteDateTime(DateTime dateTime, {String format = 'yyyy-MM-dd hh:mm a'}) {
    return DateFormat(format).format(dateTime);
  }

  // Time ago calculation
  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else {
      return '${(difference.inDays / 365).floor()} years ago';
    }
  }

  // Get day wishes based on current time
  static String dayWishes() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 18) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  // Parse string to DateTime
  static DateTime? parseDate(String dateString, {String format = 'yyyy-MM-dd'}) {
    try {
      return DateFormat(format).parse(dateString);
    } catch (e) {
      return null; // Return null if parsing fails
    }
  }

  // Parse string to Time (DateTime format without date)
  static DateTime? parseTime(String timeString, {String format = 'hh:mm a'}) {
    try {
      // Parse as if the date is today
      final now = DateTime.now();
      final parsedTime = DateFormat(format).parse(timeString);
      return DateTime(now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);
    } catch (e) {
      return null; // Return null if parsing fails
    }
  }

  // Parse string to complete DateTime (includes date and time)
  static DateTime? parseCompleteDateTime(String completeDateTimeString, {String format = 'yyyy-MM-dd hh:mm a'}) {
    try {
      return DateFormat(format).parse(completeDateTimeString);
    } catch (e) {
      return null; // Return null if parsing fails
    }
  }
}