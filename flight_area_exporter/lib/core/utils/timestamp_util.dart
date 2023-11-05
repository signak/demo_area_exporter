import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../extensions/datetime_extension.dart';
import 'logger.dart';

const timestampJsonKey = JsonKey(
  toJson: TimestampUtil.timestampFromDateValue,
  fromJson: TimestampUtil.dateFromTimestampValue,
);

class TimestampUtil {
  const TimestampUtil._();

  static DateTime? convertToDate(dynamic value, {DateTime? defaultValue}) {
    if (value != null) {
      try {
        return (value as Timestamp).toDate();
      } on Exception catch (e, st) {
        logger.e(
          "error on timestamp.toDate: '$value'",
          error: e,
          stackTrace: st,
        );
      }
    }

    return defaultValue;
  }

  static DateTime? dateFromTimestampValue(dynamic value) {
    if (value == null) {
      return null;
    } else if (value is DateTime) {
      return value;
    } else if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      final ret = DateTime.tryParse(value);
      if (ret != null) {
        return ret;
      }
    }

    throw ArgumentError.value(value, "value",
        "value is unknown type (${value?.runtimeType}). can't convert to DateTime");
  }

  static Timestamp? timestampFromDateValue(dynamic value) {
    if (value == null) {
      return null;
    } else if (value is Timestamp) {
      return value;
    } else if (value is DateTime) {
      return value.toTimestamp();
    } else if (value is String) {
      final date = DateTime.tryParse(value);
      if (date != null) {
        return date.toTimestamp();
      }
    }

    throw ArgumentError.value(value, "value",
        "value is unknown type (${value?.runtimeType}). can't convert to Timestamp");
  }
}
