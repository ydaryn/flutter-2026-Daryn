import 'models.dart';

class Library {
  final List<LibraryItem> items = [];

  late final DateTime openedAt;

  String? _cachedReport;

  void add(LibraryItem item) {
    items.add(item);
    _cachedReport = null;
  }

  Book? findByTitle(String title) {
    for (final item in items) {
      if (item is Book && item.title == title) {
        return item;
      }
    }

    return null;
  }

  String countryOf(String title) =>
      findByTitle(title)?.author.country ?? 'unknown';

  void open() {
    openedAt = DateTime.now();
  }

  String report() {
    return _cachedReport ??= items
        .map((item) => item.describe())
        .join('\n');
  }

  List<Book> get books => items.whereType<Book>().toList();

}