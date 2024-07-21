String toSnakeCase(String value) {
  // Use a regular expression to find spaces
  final words = value.split(RegExp(r"\s+"));

  // Convert each word to lowercase and join with hyphens
  return words.map((word) => word.toLowerCase()).join("-");
}
