import 'package:angular2/core.dart';
import 'package:the_zone/models/dimension.dart';
import 'package:the_zone/services/my_service.dart';
import 'package:the_zone/models/time_record.dart';

@Component(
    selector: 'body', templateUrl: 'body.html', styleUrls: const ['body.css'])
class BodyComponent {
  final MyService _myService;

  final List<Dimension> dimensions = Dimension.all;

  BodyComponent(this._myService);

  List<TimeRecord> get timeRecords => _myService.timeRecords;

  void onClick(Dimension dimensionClicked) {
    _myService.dimensionIsClicked(dimensionClicked);

    print(_myService.getActiveDimension());
  }

  Dimension getActiveDimension() => _myService.getActiveDimension();

  String getTotalDuration(Dimension dimension) {
    var duration = _myService.getTotalDuration(dimension);
    print(duration);
    return '${duration.inHours.toString().padLeft(2, '0')}'
        ':${(duration.inMinutes % 60).toString().padLeft(2, '0')}'
        ':${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }
}
