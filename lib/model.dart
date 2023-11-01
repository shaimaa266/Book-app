

import 'data_base.dart';

class Book {
  int? id;
  late String? image;
  late String? Name;
  late String? AuthorName;

  Book({
    this.id,
    required this.image,
    required this.Name,
    required this.AuthorName,
  });
  Book.fromMap(Map<String, dynamic> map) {
    if (map[ColumnId] != null) this.id = map[ColumnId];
    this.image = map[Columnimage];
    this.Name = map[ColumnName];
    this.AuthorName = map[ColumnAuthorName];
  }
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (this.id != null) map[ColumnId] = this.id;
    map[Columnimage] = this.image;
    map[ColumnName] = this.Name;
    map[ColumnAuthorName] = this.AuthorName;
    return map;
  }
}