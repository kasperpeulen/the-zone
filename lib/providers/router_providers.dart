import 'package:angular2/router.dart';
import 'package:angular2/angular2.dart';

const List routerProviders = const [
  ROUTER_PROVIDERS,
  const Provider(LocationStrategy, useClass: HashLocationStrategy)
];
