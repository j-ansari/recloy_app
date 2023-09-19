class BankList {
  final String? id;
  final int? version;
  final bool? deleted;
  final int? deletedAt;
  final String? createdDate;
  final String? lastModifiedDate;
  final String? alertHead;
  final String? banks;
  final String? country;

  BankList({
    this.id,
    this.version,
    this.deleted,
    this.deletedAt,
    this.createdDate,
    this.lastModifiedDate,
    this.alertHead,
    this.banks,
    this.country,
  });

  factory BankList.fromJson(Map<String, dynamic> json) {
    return BankList(
      id: json['id'],
      version: json['version'],
      deleted: json['deleted'],
      deletedAt: json['deletedAt'],
      createdDate: json['createdDate'],
      lastModifiedDate: json['lastModifiedDate'],
      alertHead: json['alertHead'],
      banks: json['banks'],
      country: json['country'],
    );
  }
}
