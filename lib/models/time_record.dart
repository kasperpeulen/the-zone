library time_record;

import 'dimension.dart';
import 'package:the_zone/convert.dart';

class TimeRecord {
  DateTime startedAt;
  Dimension dimension;
  DateTime endedAt;

  TimeRecord({this.startedAt, this.dimension});

  factory TimeRecord.fromJson(Map input) =>
      new TimeRecordDecoder().convert(input);

  bool get hasEnded => endedAt != null;

  Duration get duration {
    if (endedAt == null) {
      return null;
    }
    return endedAt.difference(startedAt);
  }

  String toString() {
    return 'startedAt: $startedAt '
        'endedAt: $endedAt '
        'dimension $dimension ';
  }

  Map toJson() => new TimeRecordEncoder().convert(this);
}
