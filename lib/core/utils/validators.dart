class Validators {
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price is required';
    }
    if (double.tryParse(value) == null) {
      return 'Enter a valid price';
    }
    return null;
  }

  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) return null;
    final urlRegex = RegExp(
      r'^(https?://)?([\w-]+\.)+[\w-]+(/[\w-./?%&=]*)?$',
      caseSensitive: false,
    );
    if (!urlRegex.hasMatch(value)) {
      return 'Enter a valid URL';
    }
    return null;
  }
}
