import 'package:flutter/material.dart';

class DateTimeFormatter {
  static const List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  static TimeOfDay formatTimeWithAmPm(String time) {
    List<String> split = time.split(" ");

    int hour = int.parse(split.first.split(":")[0]);
    int min = int.parse(split.first.split(":")[1]);

    String amOrPm = split.last;

    if (hour == 12) {
      if (amOrPm == "PM") {
        return TimeOfDay(hour: hour, minute: min);
      } else {
        return TimeOfDay(hour: 0, minute: min);
      }
    }

    return TimeOfDay(hour: amOrPm == "PM" ? hour + 12 : hour, minute: min);
  }

  static String formatTime(String time) {
    int hour = int.parse(time.split(":")[0]);
    String minString = time.split(":")[1];

    if (hour >= 12) {
      hour = hour - 12;
      if (hour == 0) {
        hour = 12;
      }
      String hourString;
      if (hour.toString().length == 1) {
        hourString = "0$hour";
      } else {
        hourString = hour.toString();
      }

      return "$hourString:$minString PM";
    } else {
      if (hour == 0) {
        hour = 12;
      }
      String hourString;
      if (hour.toString().length == 1) {
        hourString = "0$hour";
      } else {
        hourString = hour.toString();
      }
      return "$hourString:$minString AM";
    }
  }

  static String formatDate(DateTime dateTime) {
    return "${dateTime.day} ${getMonthString(dateTime.month)}, ${dateTime.year}";
  }

  static String formatDateTime(DateTime dateTime) {
    return "${dateTime.day}, ${getMonthString(dateTime.month)}, ${dateTime.year}   ||   ${dateTime.hour.toString().padLeft(2, '0')} : ${dateTime.minute.toString().padLeft(2, '0')}";
  }

  static String formatDateServer(var dateTimeValue) {
    DateTime? dateTime;

    if (dateTimeValue.runtimeType == String) {
      dateTime = stringToDate(dateTimeValue);
    }

    if (dateTimeValue.runtimeType == DateTime) dateTime = dateTimeValue;

    String month = dateTime!.month.toString();
    if (month.length == 1) month = "0$month";

    String day = dateTime.day.toString();
    if (day.length == 1) day = "0$day";

    return "${dateTime.year}-$month-$day";
  }

  static DateTime stringToDate(String dateTime) {
    assert(dateTime.contains(",") && dateTime.contains(" "));
    List<String> splitDateTime = dateTime.split(",").toList();
    int year = int.parse(splitDateTime[1]);
    String dayAndMonth = splitDateTime[0];
    int day = int.parse(dayAndMonth.split(" ")[0]);
    int month = getMonthInt(dayAndMonth.split(" ")[1]);

    return DateTime(year, month, day);
  }

  static DateTime stringToDateWithTime(String date, String time) {
    assert(date.contains(",") && date.contains(" "));

    List<String> splitDateTime = date.split(",").toList();
    int year = int.parse(splitDateTime[1]);
    String dayAndMonth = splitDateTime[0];
    int day = int.parse(dayAndMonth.split(" ")[0]);
    int month = getMonthInt(dayAndMonth.split(" ")[1]);

    int hours = 0;
    int mins = 0;

    if (time.isNotEmpty) {
      List<String> splitTime = time.split(":").toList();
      hours = int.parse(splitTime[0]);
      mins = int.parse(splitTime[1]);
    }

    return DateTime(year, month, day, hours, mins);
  }

  static DateTime stringToDateServer(String dateTime) {
    assert(dateTime.contains("-"));
    List<int> splitDateTime =
        dateTime.split("-").toList().map((x) => int.parse(x)).toList();

    return DateTime(splitDateTime[0], splitDateTime[1], splitDateTime[2]);
  }

  static int getNoOfDays(var date1, var date2) {
    if (date1.runtimeType == String) {
      DateTime newDate = stringToDate(date1);
      DateTime newDate2 = stringToDate(date2);

      assert(newDate2.isAfter(newDate));
      return newDate2.difference(newDate).inDays;
    }

    assert(date2.isAfter(date1));
    return date2.difference(date1).inDays;
  }

  static String getMonthString(int monthInt) {
    return months[monthInt - 1];
  }

  static int getMonthInt(String monthString) {
    for (int i = 0; i < months.length; i++) {
      if (months[i].toLowerCase() == monthString.toLowerCase()) {
        return i + 1;
      }
    }

    return -1;
  }

  static String getTwoLetterNumber(int x) {
    if (x.toString().length == 1) {
      return "0$x";
    }
    return x.toString();
  }
}
