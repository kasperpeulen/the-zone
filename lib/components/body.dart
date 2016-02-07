import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'dart:async';
import 'package:the_zone/services/time_record_service.dart';
import 'package:the_zone/components/main.dart';

@Component(
    selector: 'body', templateUrl: 'body.html', styleUrls: const ['body.css'])
@RouteConfig(const [
  const AsyncRoute(
      path: '',
      loader: BodyComponent.loadMainComponent,
      name: 'Main',
      useAsDefault: true),
])
class BodyComponent {
  final TimeRecordService _recorder;

  BodyComponent(this._recorder) {
    _completer.complete(_recorder);
  }

  static Future loadMainComponent() async => loadRoute(MainComponent);

  static Future loadRoute(Type type) async {
    final recorder = await _completer.future;
    await recorder.loaded;
    return type;
  }
}

// This is a hack to get a service in a static method above
Completer<TimeRecordService> _completer = new Completer();
