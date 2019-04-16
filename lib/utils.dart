import 'package:timeago/timeago.dart' as timeago;

String getAbbreviatedTimeSpan(DateTime time) {
  return timeago.format(time, locale: 'en_short');
}