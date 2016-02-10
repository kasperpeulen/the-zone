import 'package:logging/logging.dart';
import 'package:angular2/angular2.dart';
import 'app_providers.dart';
import 'package:intl/intl.dart';

Logger initLog(String appName, AppMode appMode) {
  Logger.root.level = appMode == AppMode.develop ? Level.ALL : Level.INFO;
  Logger.root.onRecord
      .where((r) => r.loggerName == appName)
      .map(_stringify)
      .forEach(print);

  return new Logger(appName);
}

DateFormat _dateFormatter = new DateFormat("H:m:s.S");

String _stringify(LogRecord rec) =>
    '${rec.level.name}-${rec.loggerName.toUpperCase()}-${_dateFormatter.format(rec.time)}\n'
        '${rec.message}\n'
        .replaceAll('\n', '\n ')
        .trim();
