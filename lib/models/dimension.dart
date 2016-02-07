library dimension;

enum Dimension { zone, demand, delusion, distraction }

final List<String> _dimensionNames = [
  "The Zone",
  "Demand",
  "Delusion",
  "Distraction"
];

String getDimensionName(Dimension dimension) =>
    _dimensionNames[dimension.index];
