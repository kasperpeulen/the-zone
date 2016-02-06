class Dimension {
  static const Dimension zone = const Dimension._('The Zone','Important, Not Urgent');
  static const Dimension demand = const Dimension._('Demand','Important, Urgent');
  static const Dimension delusion = const Dimension._('Delusion','Not Important, Urgent');
  static const Dimension distraction = const Dimension._('Distraction','Not Important, Not Urgent');

  static const List<Dimension> all = const [
    zone,
    demand,
    delusion,
    distraction
  ];

  final String name;
  final String info;

  const Dimension._(this.name,this.info);

  String toString() => '$name';
}