import 'package:grinder/grinder.dart';
import 'package:dogma_codegen/build.dart';
import 'package:watcher/watcher.dart';
import 'dart:async';

void main(List<String> args) {
  grind(args);
}

@Task()
@Depends(analyze, testFormat)
void travis() {}

@DefaultTask()
@Depends(analyze, format)
void prePush() {}

@Task()
void analyze() {
  Analyzer.analyze(existingSourceDirs);
}

@Task('Apply dartfmt to all Dart source files')
void format() {
  DartFmt.format(existingSourceDirs);
}

@Task('Test dartfmt for all Dart source files')
void testFormat() {
  if (DartFmt.dryRun(existingSourceDirs)) {
    throw "dartfmt failure";
  }
}

@Task('Deploy to firebase')
void deploy() {
  Pub.build(directories: ['web']);
  run('firebase', arguments: ['deploy']);
}

@Task()
Future buildDogma() async {
  await build([],
      modelPath: 'lib/models',
      convertPath: 'lib/convert',
      mapper: false,
      unmodifiable: false);
}

@Task()
Future watchDogma() async {
  await for (var _ in new Watcher('lib/models').events) {
    await buildDogma();
  }
}
