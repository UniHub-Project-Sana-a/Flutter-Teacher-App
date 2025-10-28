// lib/utils/date_utils_ar.dart
// دوال مساعدة للتواريخ باللغة العربية

/// اسم الشهر بالعربية (1..12)
String monthNameAr(int month) {
  const months = [
    'يناير','فبراير','مارس','أبريل','مايو','يونيو',
    'يوليو','أغسطس','سبتمبر','أكتوبر','نوفمبر','ديسمبر'
  ];
  if (month < 1 || month > 12) return '';
  return months[month - 1];
}

/// اسم يوم الأسبوع قصير بالعربية
/// ملاحظة: DateTime.weekday = الإثنين(1) .. الأحد(7)
String weekdayShortAr(int weekday) {
  switch (weekday) {
    case DateTime.monday:
      return 'الإثنين';
    case DateTime.tuesday:
      return 'الثلاثاء';
    case DateTime.wednesday:
      return 'الأربعاء';
    case DateTime.thursday:
      return 'الخميس';
    case DateTime.friday:
      return 'الجمعة';
    case DateTime.saturday:
      return 'السبت';
    case DateTime.sunday:
      return 'الأحد';
    default:
      return '';
  }
}

/// مقارنة يومين (اليوم/الشهر/السنة فقط)
bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}