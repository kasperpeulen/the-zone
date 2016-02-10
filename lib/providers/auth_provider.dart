import 'dart:async';
import 'package:github/browser.dart';
import 'package:firebase/firebase.dart';
import 'package:angular2/angular2.dart';

Future<List> getAuthProviders() async {
  final firebase = new Firebase('http://the-zone.firebaseio.com/');
  final auth = await _bootstrapAuth(firebase);
  return [
    provide(Firebase, useValue: firebase),
    provide(Authentication, useValue: auth),
    provide(GitHub,
        useFactory: (Authentication auth) => createGitHubClient(auth: auth),
        deps: [Authentication])
  ];
}

Future<Authentication> _bootstrapAuth(Firebase firebase) async {
  final authData = await firebase.onAuth().first;
  if (authData != null && authData['provider'] == 'github') {
    firebase
        .child("users")
        .child(authData['uid'])
        .child('username')
        .set(authData['github']['username']);

    return new Authentication.withToken(authData['github']['accessToken']);
  } else {
    return new Authentication.anonymous();
  }
}
