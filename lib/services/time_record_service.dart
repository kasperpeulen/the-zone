import 'package:angular2/core.dart';
import 'package:the_zone/models/time_record.dart';
import 'package:the_zone/models/dimension.dart';

@Injectable()
class TimeRecordService {
  List<TimeRecord> timeRecords = [];

  /// THe current time record. Returns null if there are no records yet,
  /// or if the last record is already ended.
  TimeRecord getCurrentRecord() {
    if (timeRecords.isEmpty) {
      return null;
    }
    if (timeRecords.last.hasEnded) {
      return null;
    }
    return timeRecords.last;
  }

  void dimensionIsClicked(Dimension dimensionClicked) {
    TimeRecord currentRecord = getCurrentRecord();
    if (currentRecord != null) {
      // end the record
      currentRecord.endedAt = new DateTime.now();

      // don't create a new timer when the dimension clicked
      // is the same as the currentRecord
      if (currentRecord.dimension == dimensionClicked) {
        return;
      }
    }

    timeRecords.add(new TimeRecord(
        startedAt: new DateTime.now(), dimension: dimensionClicked));
    print(timeRecords);
  }

  Dimension getActiveDimension() => getCurrentRecord()?.dimension;

  Duration getTotalDuration(Dimension dimension) {
    Duration duration = new Duration(seconds: 0);
    for (TimeRecord record in timeRecords) {
      if (record.duration != null && record.dimension == dimension) {
        duration += record.duration;
      }
    }
    return duration;
  }
}
