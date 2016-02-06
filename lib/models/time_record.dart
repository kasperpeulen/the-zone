import 'dimension.dart';

class TimeRecord {
  DateTime startedAt;
  DateTime endedAt;

  Dimension dimension;

  TimeRecord({this.startedAt, this.dimension});

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
}
