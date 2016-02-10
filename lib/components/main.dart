import 'dart:async';
import 'dart:html' show window;

import 'package:angular2/core.dart';
import 'package:the_zone/services/time_record_service.dart';
import 'package:the_zone/models/time_record.dart';
import 'package:the_zone/services/auth_service.dart';
import 'package:the_zone/models/dimension.dart';
import 'package:the_zone/components/spinner.dart';
import 'package:logging/logging.dart';

@Component(
    selector: 'main',
    templateUrl: 'main.html',
    styleUrls: const ['main.css'],
    directives: const [SpinnerComponent],
    pipes: const [GetDimensionName])
class MainComponent {
  final TimeRecordService _recorder;
  final AuthService _auth;
  final Logger _log;

  MainComponent(this._recorder, this._auth, this._log) {
    _log.fine('Routed to main component.');
    // update view periodic
    new Timer.periodic(new Duration(seconds: 1), (_) {});
  }

  bool get recordingsLoaded => _recorder.recordingsLoaded;

  final List<Dimension> dimensions = Dimension.values;

  List<TimeRecord> get recordings => _recorder.recordings;

  void activate(Dimension dimension) {
    bool isCurrent = isRecording(dimension);
    _recorder.stop();
    if (isCurrent) return;
    _recorder.record(dimension);
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

  num getPercentageDuration(Dimension dimension) =>
      _recorder.percentageDuration(dimension);

  void resetRecordings() => _recorder.resetRecordings();

  Future login() => _auth.login();

  Future logout() async {
    await _auth.logout();
    window.location.reload();
  }

  bool get isLoggedIn => _auth.isLoggedIn;

  String get username => _auth.user?.login;
}

@Pipe(name: 'getDimensionName')
class GetDimensionName implements PipeTransform {
  String transform(Dimension dimension, [List args]) =>
      getDimensionName(dimension);
}
