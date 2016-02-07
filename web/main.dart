import 'dart:async';

import 'package:angular2/bootstrap.dart';
import 'package:angular2/angular2.dart';
import 'package:the_zone/components/body.dart';
import 'package:the_zone/services/time_record_service.dart';
import 'package:firebase/firebase.dart';
import 'package:github/browser.dart';
import 'package:the_zone/services/auth_service.dart';

Future main() async {
  final firebase = new Firebase('http://the-zone.firebaseio.com/');

  bootstrap(BodyComponent, [
    TimeRecordService,
    AuthService,
    provide(Firebase, useValue: firebase),
    provide(Authentication, useValue: await bootstrapAuth(firebase)),
    provide(GitHub,
        useFactory: (Authentication auth) => createGitHubClient(auth: auth),
        deps: [Authentication]),
  ]);
}

Future<Authentication> bootstrapAuth(Firebase firebase) async {
  final authJson = await firebase.onAuth().first;
  if (authJson != null && authJson['provider'] == 'github') {
    return new Authentication.withToken(authJson['github']['accessToken']);
  } else {
    return new Authentication.anonymous();
  }
}
