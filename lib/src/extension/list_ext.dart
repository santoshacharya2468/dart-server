extension ListExt<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) func) {
    for (var element in this) {
      if (func(element)) return element;
    }
    return null;
  }
}
