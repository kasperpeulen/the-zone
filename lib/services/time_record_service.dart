import 'package:angular2/core.dart';
import 'package:the_zone/models/time_record.dart';
import 'package:the_zone/models/dimension.dart';
import 'storage_service.dart';
import 'dart:async';

@Injectable()
class TimeRecordService {
  final StorageService _storage;
  TimeRecordService(this._storage) {
    loaded = _storage.loadRecordings().then((r) {
      if (r != null) {
        recordings = r;
      }
    });
  }

  /// Returnrs when data is fetched from firebase.
  Future loaded;

  List<TimeRecord> recordings = [];

  /// The current time record. Returns null if there are no records yet,
  /// or if the last record is already ended.
  TimeRecord get currentRecord =>
      recordings.isEmpty || recordings.last.hasEnded ? null : recordings.last;

  void dimensionIsClicked(Dimension dimension) {
    if (currentRecord != null) {
      // end the record
      currentRecord.endedAt = new DateTime.now();

      // don't create a new timer when the dimension clicked
      // is the same as the currentRecord
      if (recordings.last.dimension == dimension) return;
    }

    recordings.add(
        new TimeRecord(startedAt: new DateTime.now(), dimension: dimension));

    _storage.save(recordings);
  }

  Duration getTotalDuration(Dimension dimension) {
    Duration duration = new Duration(seconds: 0);
    for (TimeRecord record in recordings) {
      if (record.duration != null && record.dimension == dimension) {
        duration += record.duration;
      }
    }
    return duration;
  }

  int percentageDuration(Dimension dimension) {
    final Duration total = Dimension.values
        .map((d) => getTotalDuration(d))
        .reduce((v, e) => v + e);
    final duration = getTotalDuration(dimension);
    return duration.inSeconds / total.inSeconds;
  }

  void resetRecordings() {
    recordings = [];
    _storage.reset();
  }
}
