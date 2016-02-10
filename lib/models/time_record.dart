library time_record;

import 'dimension.dart';
import 'package:the_zone/convert.dart';
import 'package:dogma_convert/serialize.dart';

class TimeRecord {
  @Serialize.field('startedAt')
  DateTime startedAt = new DateTime.now().toUtc();

  @Serialize.field('dimension')
  Dimension dimension;

  @Serialize.field('endedAt', optional: true)
  DateTime endedAt;

  String get uid => startedAt.millisecondsSinceEpoch.toString();

  TimeRecord({this.dimension});

  factory TimeRecord.fromJson(Map input) =>
      new TimeRecordDecoder().convert(input);

  bool get hasEnded => endedAt != null;

  Duration get duration {
    if (endedAt == null) {
      return new DateTime.now().toUtc().difference(startedAt);
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
