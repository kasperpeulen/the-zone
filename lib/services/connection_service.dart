import 'package:angular2/core.dart';
import 'package:firebase/firebase.dart';
import 'dart:html';

@Injectable()
class ConnectionService {
  ConnectionService() {
    var connectedRef =
        new Firebase("https://the-zone.firebaseio.com/.info/connected");
    connectedRef.onValue.listen((snap) {
      if (snap.snapshot.val() == true) {
        connectedToFB.add(true);
      } else {
        connectedToFB.add(false);
      }
    });
  }

  EventEmitter<bool> connectedToFB = new EventEmitter();

  bool get onLine => window.navigator.onLine;

  bool get offLine => !onLine;
}
