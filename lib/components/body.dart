import 'dart:async';
import 'dart:html' show window;

import 'package:angular2/core.dart';
import 'package:the_zone/models/dimension.dart';
import 'package:the_zone/services/time_record_service.dart';
import 'package:the_zone/models/time_record.dart';
import 'package:the_zone/services/auth_service.dart';

@Component(
    selector: 'body', templateUrl: 'body.html', styleUrls: const ['body.css'])
class BodyComponent {
  final TimeRecordService _recorder;
  final AuthService _auth;

  BodyComponent(this._recorder, this._auth);

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

  Future login() => _auth.login();

  Future logout() async {
    await _auth.logout();
    window.location.reload();
  }

  bool get isLoggedIn => _auth.isLoggedIn;

  String get username => _auth.user?.login;
}
