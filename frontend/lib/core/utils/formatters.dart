import 'package:intl/intl.dart';

class Formatters {
  const Formatters._();

  static String date(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  static String dateShort(DateTime dateTime) {
    return DateFormat('dd/MM/yy').format(dateTime);
  }

  static String time(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  static String dateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  static String timeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  static String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  static String currency(double amount) {
    return NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(amount);
  }

  static String number(int value) {
    return NumberFormat('#,##,###').format(value);
  }
}
