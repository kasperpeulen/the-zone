import 'package:angular2/core.dart';
import 'package:firebase/firebase.dart';
import 'dart:html';
import 'package:logging/logging.dart';

@Injectable()
class ConnectionService {
  final Logger _log;

  ConnectionService(this._log) {
    var connectedRef =
        new Firebase("https://the-zone.firebaseio.com/.info/connected");
    connectedRef.onValue.listen((snap) {
      if (snap.snapshot.val() == true) {
        _log.info('Succesfully connected to firebase');
        connectedToFB.add(true);
      } else {
        _log.info('Not connected to firebase');
        connectedToFB.add(false);
      }
    });
  }

  EventEmitter<bool> connectedToFB = new EventEmitter();

  bool get onLine => window.navigator.onLine;

  bool get offLine => !onLine;
}

enum Connection { onLine, offLine }
