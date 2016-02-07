import 'dimension.dart';

class TimeRecord {
  final DateTime startedAt;
  final Dimension dimension;

  DateTime endedAt;

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
