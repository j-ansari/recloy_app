class CategoryModel {
  final String? id;
  final int? version;
  final bool? deleted;
  final String? createdDate;
  final String? lastModifiedDate;
  final String? name;
  final String? lang;
  final String? tagType;

  CategoryModel({
    this.id,
    this.version,
    this.deleted,
    this.createdDate,
    this.lastModifiedDate,
    this.name,
    this.lang,
    this.tagType,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      version: json['version'],
      deleted: json['deleted'],
      createdDate: json['createdDate'],
      lastModifiedDate: json['lastModifiedDate'],
      name: json['name'],
      lang: json['lang'],
      tagType: json['tagType'],
    );
  }
}
