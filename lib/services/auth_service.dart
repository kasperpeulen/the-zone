import 'package:angular2/core.dart';
import 'package:firebase/firebase.dart';
import 'package:github/browser.dart';
import 'dart:html';
import 'dart:async';


@Injectable()
class AuthService {
  final Firebase _firebase;
  final GitHub _gitHub;
  final Authentication _auth;

  CurrentUser _user;

  /// May be null.
  CurrentUser get user => _user;

  AuthService(this._gitHub, this._firebase, this._auth) {
    if (_gitHub.auth.isToken) {
      _gitHub.users.getCurrentUser().then((user) => _user = user);
    }
  }

  Future<Null> login() async {
    _firebase.authWithOAuthRedirect('github');
  }

  Future<Null> logout() async {
    _firebase.unauth();
    window.location.reload();
  }

  bool get isLoggedIn => _auth.isAnonymous ? false : true;
}