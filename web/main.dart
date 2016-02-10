import 'dart:async';

import 'package:angular2/bootstrap.dart';
import 'package:angular2/angular2.dart';
import 'package:the_zone/components/body.dart';
import 'package:the_zone/services/time_record_service.dart';
import 'package:firebase/firebase.dart';
import 'package:github/browser.dart';
import 'package:the_zone/services/auth_service.dart';
import 'package:the_zone/services/storage_service.dart';
import 'package:angular2/router.dart';
import 'package:the_zone/services/connection_service.dart';

Future main() async {
  await new Future.delayed(new Duration(seconds: 2));
  final firebase = new Firebase('http://the-zone.firebaseio.com/');

  await bootstrap(BodyComponent, [
    ROUTER_PROVIDERS,
    provide(LocationStrategy, useClass: HashLocationStrategy),
    TimeRecordService,
    ConnectionService,
    AuthService,
    StorageService,
    provide(Firebase, useValue: firebase),
    provide(Authentication, useValue: await bootstrapAuth(firebase)),
    provide(GitHub,
        useFactory: (Authentication auth) => createGitHubClient(auth: auth),
        deps: [Authentication]),
  ]);
}

Future<Authentication> bootstrapAuth(Firebase firebase) async {
  final authData = await firebase.onAuth().first;
  if (authData != null && authData['provider'] == 'github') {
    firebase
        .child("users")
        .child(authData['uid'])
        .child('username')
        .set(authData['github']['username']);

    // TODO: need to find out why this is needed
    // and how it can be done better
    return new Authentication.withToken(authData['github']['accessToken']);
  } else {
    return new Authentication.anonymous();
  }
}
