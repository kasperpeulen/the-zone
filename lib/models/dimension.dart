class DimensionInfo {
  String name;
  String info;

  DimensionInfo(this.name, this.info);
}

class Dimension {
  static const String zone = 'The Zone';
  static const String demand = 'Demand';
  static const String delusion = 'Delusion';
  static const String distraction = 'Distraction';

  static const List<String> all = const [
    zone,
    demand,
    delusion,
    distraction
  ];
}