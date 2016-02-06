class Dimension {

  static const Dimension zone = const Dimension('The Zone','Important, Not Urgent');
  static const Dimension demand = const Dimension('Demand','Important, Urgent');
  static const Dimension delusion = const Dimension('Delusion','Not Important, Urgent');
  static const Dimension distraction = const Dimension('Distraction','Not Important, Not Urgent');

  static const List<Dimension> all = const [
    zone,
    demand,
    delusion,
    distraction
  ];

  final String name;
  final String info;

  const Dimension(this.name,this.info);

  toString() => name;

}
