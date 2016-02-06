import 'package:angular2/core.dart';
import 'package:the_zone/models/dimension.dart';
import 'package:the_zone/services/time_record_service.dart';
import 'package:the_zone/models/time_record.dart';

@Component(
    selector: 'body', templateUrl: 'body.html', styleUrls: const ['body.css'])
class BodyComponent {
  final TimeRecordService _recorder;

  BodyComponent(this._recorder);

  final List<Dimension> dimensions = Dimension.all;

  List<TimeRecord> get recordings => _recorder.recordings;

  void activate(Dimension dimension) {
    _recorder.dimensionIsClicked(dimension);
  }

  Dimension getActiveDimension() => _recorder.getActiveDimension();

  bool isActive(Dimension dimension) =>
      dimension == _recorder.getActiveDimension();

  String getTotalDuration(Dimension dimension) {
    final duration = _recorder.getTotalDuration(dimension);
    return '${duration.inHours.toString().padLeft(2, '0')}'
        ':${(duration.inMinutes % 60).toString().padLeft(2, '0')}'
        ':${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }
}
