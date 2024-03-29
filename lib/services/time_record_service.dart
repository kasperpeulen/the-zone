import 'package:angular2/core.dart';
import 'package:the_zone/models/time_record.dart';
import 'package:the_zone/models/dimension.dart';
import 'storage_service.dart';
import 'dart:async';

@Injectable()
class TimeRecordService {
  final StorageService _storage;

  TimeRecordService(this._storage) {
    _storage.loaded.then((_) => _recordingsLoaded = true);
  }

  bool _recordingsLoaded = false;

  bool get recordingsLoaded => _recordingsLoaded;

  /// Returns all recordings
  List<TimeRecord> get recordings => _storage.recordings;

  /// The current time record. Returns null if there are no records yet,
  /// or if the last record is already ended.
  TimeRecord get currentRecord =>
      recordings.firstWhere((r) => !r.hasEnded, orElse: () => null);

  /// Verifies if there's a recording in progress
  bool get isRecording => currentRecord != null;

  /// Stops and saves the current recording
  void stop() {
    if (!isRecording) return;
    final recording = currentRecord;
    recording.endedAt = new DateTime.now().toUtc();
    _storage.update(recording);
  }

  void record(Dimension dimension) {
    if (isRecording) throw "There's a recording in progress already";

    final recording = new TimeRecord(dimension: dimension);
    _storage.push(recording);
  }

  Duration getTotalDuration(Dimension dimension) {
    var duration = new Duration(seconds: 0);
    for (TimeRecord record in recordings) {
      if (record.duration != null && record.dimension == dimension) {
        duration += record.duration;
      }
    }
    return duration;
  }

  num percentageDuration(Dimension dimension) {
    final Duration total = Dimension.values
        .map((d) => getTotalDuration(d))
        .reduce((v, e) => v + e);
    final duration = getTotalDuration(dimension);
    final result = duration.inSeconds / total.inSeconds;
    return result.isNaN ? 0 : result;
  }

  void resetRecordings() => _storage.reset();
}
