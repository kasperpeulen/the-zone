import 'package:angular2/core.dart';
import 'package:the_zone/models/time_record.dart';
import 'package:the_zone/models/dimension.dart';
import 'storage_service.dart';

@Injectable()
class TimeRecordService {
  final StorageService _storage;
  TimeRecordService(this._storage) {
    _storage.loadRecordings().then((r) {
      recordings = r;
    });
  }

  List<TimeRecord> recordings = [];

  /// THe current time record. Returns null if there are no records yet,
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
}
