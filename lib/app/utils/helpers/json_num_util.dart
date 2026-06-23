/// Safely coerce JSON/API numeric values (int, double, or numeric string) to [num].
num? readJsonNum(dynamic value) {
  if (value == null) return null;
  if (value is num) return value;
  if (value is String) return num.tryParse(value);
  return null;
}

num readJsonNumOrZero(dynamic value) => readJsonNum(value) ?? 0;
