import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:the_zone/components/main.dart';
import 'package:logging/logging.dart';

@Component(
    selector: 'app', templateUrl: 'body.html', styleUrls: const ['body.css'])
@RouteConfig(const [
  const Route(
      path: '', component: MainComponent, name: 'Main', useAsDefault: true),
])
class BodyComponent {
  final Logger _log;

  BodyComponent(this._log) {
    _log.fine('BodyComponent loaded');
  }
}
