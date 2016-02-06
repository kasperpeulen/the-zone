import 'package:angular2/core.dart';
import 'package:the_zone/models/dimension.dart';
import 'package:the_zone/services/my_service.dart';
import 'package:the_zone/models/time_record.dart';
import 'package:the_zone/services/user_service.dart';
import 'dart:async';

@Component(
    selector: 'body', templateUrl: 'body.html', styleUrls: const ['body.css'])
class BodyComponent {
  final MyService _myService;
  final UserService _userService;

  BodyComponent(this._myService, this._userService);

  final List<Dimension> dimensions = Dimension.all;

  List<TimeRecord> get timeRecords => _myService.timeRecords;

  void onClick(String dimensionClicked) {
    _myService.dimensionIsClicked(dimensionClicked);

    print(_myService.getActiveDimension());
  }

  Dimension getActiveDimension() => _myService.getActiveDimension();

  bool isActive(Dimension dimension) => dimension == getActiveDimension();

  String getTotalDuration(Dimension dimension) {
    final duration = _myService.getTotalDuration(dimension);
    return '${duration.inHours.toString().padLeft(2, '0')}'
        ':${(duration.inMinutes % 60).toString().padLeft(2, '0')}'
        ':${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Future login() => _userService.login();

  Future logout() => _userService.logout();

  bool get loggedIn => _userService.loggedIn;

  String get userName => _userService.user?.login;
}
