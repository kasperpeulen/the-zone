import 'package:grinder/grinder.dart';

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
