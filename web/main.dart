import 'dart:async';

import 'package:angular2/bootstrap.dart';
import 'package:the_zone/components/body.dart';
import 'package:the_zone/providers/auth_provider.dart';
import 'package:the_zone/providers/router_providers.dart';
import 'package:the_zone/providers/app_providers.dart';

Future main() async {
  final authProviders = await getAuthProviders();
  await bootstrap(BodyComponent,
      []..addAll(routerProviders)..addAll(appProviders)..addAll(authProviders));
}
