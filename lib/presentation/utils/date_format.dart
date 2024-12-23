import 'package:intl/intl.dart';

String formatDate(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return DateFormat('EEEE, dd-MM-yyyy').format(date);
}
