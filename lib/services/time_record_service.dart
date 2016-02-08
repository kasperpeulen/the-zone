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

  /// Returns when data is fetched from firebase.
  Future loaded;

  List<TimeRecord> recordings = [];

  /// The current time record. Returns null if there are no records yet,
  /// or if the last record is already ended.
  TimeRecord get currentRecord =>
      recordings.isEmpty || recordings.last.hasEnded ? null : recordings.last;

  /// Verifies if there's a recording in progress
  bool get isRecording => currentRecord != null;

  /// Stops and saves the current recording
  void stop(){
    if(!isRecording) return;

    currentRecord.endedAt = new DateTime.now();
    _storage.save(recordings);
  }

  void record(Dimension dimension){
    if(isRecording)
      throw "There's a recording in progress already";

    final now = new DateTime.now();
    final recording = new TimeRecord(startedAt: now, dimension: dimension);
    recordings.add(recording);
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

  num percentageDuration(Dimension dimension) {
    final Duration total = Dimension.values
        .map((d) => getTotalDuration(d))
        .reduce((v, e) => v + e);
    final duration = getTotalDuration(dimension);
    num result = duration.inSeconds / total.inSeconds;
    return result.isNaN ? 0 : result;
  }

  void resetRecordings() {
    recordings = [];
    _storage.reset();
  }
}
