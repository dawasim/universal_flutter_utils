extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  double formatUpTo({int maxDecimalPoints = 2}) {
    double value = double.tryParse(this ?? '') ?? 0.0;
    String formattedValue = value.toStringAsFixed(maxDecimalPoints);
    return double.parse(formattedValue);
  }
}
