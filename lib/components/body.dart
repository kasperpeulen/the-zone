import 'package:angular2/core.dart';
import 'package:the_zone/models/dimension.dart';
import 'package:the_zone/services/time_record_service.dart';
import 'package:the_zone/models/time_record.dart';
import 'package:the_zone/services/auth_service.dart';
import 'dart:async';

@Component(
    selector: 'body', templateUrl: 'body.html', styleUrls: const ['body.css'])
class BodyComponent {
  final TimeRecordService _recorder;
  final AuthService _authService;

  BodyComponent(this._recorder, this._authService);

  final List<Dimension> dimensions = Dimension.all;

  List<TimeRecord> get recordings => _recorder.recordings;

  void activate(Dimension dimension) {
    _recorder.dimensionIsClicked(dimension);
  }

  bool isRecording(Dimension dimension) {
    Dimension current = _recorder.currentRecord?.dimension;
    return dimension == current;
  }

  String getTotalDuration(Dimension dimension) {
    final duration = _recorder.getTotalDuration(dimension);
    return '${duration.inHours.toString().padLeft(2, '0')}'
        ':${(duration.inMinutes % 60).toString().padLeft(2, '0')}'
        ':${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Future login() => _authService.login();

  Future logout() => _authService.logout();

  bool get isLoggedIn => _authService.isLoggedIn;

  String get username => _authService.user?.login;
}
