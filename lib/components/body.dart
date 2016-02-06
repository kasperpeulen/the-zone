import 'package:angular2/core.dart';
import 'package:the_zone/models/dimension.dart';
import 'package:the_zone/services/my_service.dart';
import 'package:the_zone/models/time_record.dart';

@Component(
    selector: 'body', templateUrl: 'body.html', styleUrls: const ['body.css'])
class BodyComponent {
  final MyService _myService;

  BodyComponent(this._myService);

  final List<DimensionInfo> dimensions = [
    new DimensionInfo(Dimension.zone, 'Important, Not Urgent'),
    new DimensionInfo(Dimension.demand, 'Important, Urgent'),
    new DimensionInfo(Dimension.delusion, 'Not Important, Urgent'),
    new DimensionInfo(Dimension.distraction, 'Not Important, Not Urgent'),
  ];

  List<TimeRecord> get timeRecords => _myService.timeRecords;

  void onClick(String dimensionClicked) {
    _myService.dimensionIsClicked(dimensionClicked);

    print(_myService.getActiveDimension());
  }

  String getActiveDimension() => _myService.getActiveDimension();

  Duration getTotalDuration(String dimension) =>
      _myService.getTotalDuration(dimension);
}
