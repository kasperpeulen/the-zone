import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'dart:async';
import 'package:the_zone/components/main.dart';
import 'package:the_zone/services/storage_service.dart';

@Component(
    selector: 'app', templateUrl: 'body.html', styleUrls: const ['body.css'])
@RouteConfig(const [
  const Route(
      path: '', component: MainComponent, name: 'Main', useAsDefault: true),
])
class BodyComponent {}
