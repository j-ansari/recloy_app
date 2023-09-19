class SmsDetailModel {
  late List<Content>? content;
  final Pageable? pageable;
  final int? totalPages;
  final int? totalElements;
  final bool? last;
  final int? size;
  final int? number;
  final Sort? sort;
  final int? numberOfElements;
  final bool? first;
  final bool? empty;

  SmsDetailModel({
    this.content,
    this.pageable,
    this.totalPages,
    this.totalElements,
    this.last,
    this.size,
    this.number,
    this.sort,
    this.numberOfElements,
    this.first,
    this.empty,
  });

  factory SmsDetailModel.fromJson(Map<String, dynamic> json) {
    var content = <Content>[];
    if (json['content'] != null) {
      json['content'].forEach((v) {
        content.add(Content.fromJson(v));
      });
    }
    return SmsDetailModel(
      pageable:
          json['pageable'] != null ? Pageable.fromJson(json['pageable']) : null,
      totalPages: json['totalPages'],
      totalElements: json['totalElements'],
      last: json['last'],
      size: json['size'],
      number: json['number'],
      sort: json['sort'] != null ? Sort.fromJson(json['sort']) : null,
      numberOfElements: json['numberOfElements'],
      first: json['first'],
      empty: json['empty'],
      content: content,
    );
  }
}

class Content {
  final String? id;
  final int? version;
  final bool? deleted;
  final int? deletedAt;
  final String? createdDate;
  final String? lastModifiedDate;
  final String? date;
  final String? messageHash;
  final String? messageType;
  final double? amount;
  final String? metaData;
  final String? originalDataBase64;
  final String? cardNumber;
  final String? operationDate;
  final String? place;
  final String? currency;
  final User? user;
  final SmsNumberAlert? smsNumberAlert;
  final Tag? tag;
  final Category? category;
  final double? balanceValue;

  Content({
    this.id,
    this.version,
    this.deleted,
    this.deletedAt,
    this.createdDate,
    this.lastModifiedDate,
    this.date,
    this.messageHash,
    this.messageType,
    this.amount,
    this.metaData,
    this.originalDataBase64,
    this.cardNumber,
    this.operationDate,
    this.place,
    this.currency,
    this.user,
    this.smsNumberAlert,
    this.tag,
    this.category,
    this.balanceValue,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['id'],
      version: json['version'],
      deleted: json['deleted'],
      deletedAt: json['deletedAt'],
      createdDate: json['createdDate'],
      lastModifiedDate: json['lastModifiedDate'],
      date: json['date'],
      messageHash: json['messageHash'],
      messageType: json['messageType'],
      amount: json['amount'],
      metaData: json['metaData'],
      originalDataBase64: json['originalDataBase64'],
      cardNumber: json['cardNumber'],
      operationDate: json['operationDate'],
      place: json['place'],
      currency: json['currency'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      smsNumberAlert: json['smsNumberAlert'] != null
          ? SmsNumberAlert.fromJson(json['smsNumberAlert'])
          : null,
      tag: json['tag'] != null ? Tag.fromJson(json['tag']) : null,
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
      balanceValue: json['balanceValue'],
    );
  }
}

class User {
  final String? id;
  final int? version;
  final bool? deleted;
  final int? deletedAt;
  final String? createdDate;
  final String? lastModifiedDate;
  final String? mobile;
  final String? firstName;
  final String? lastName;
  final String? imei;

  User({
    this.id,
    this.version,
    this.deleted,
    this.deletedAt,
    this.createdDate,
    this.lastModifiedDate,
    this.mobile,
    this.firstName,
    this.lastName,
    this.imei,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      version: json['version'],
      deleted: json['deleted'],
      deletedAt: json['deletedAt'],
      createdDate: json['createdDate'],
      lastModifiedDate: json['lastModifiedDate'],
      mobile: json['mobile'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      imei: json['imei'],
    );
  }
}

class SmsNumberAlert {
  final String? id;
  final int? version;
  final bool? deleted;
  final int? deletedAt;
  final String? createdDate;
  final String? lastModifiedDate;
  final String? alertHead;
  final String? banks;
  final String? country;

  SmsNumberAlert({
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

  factory SmsNumberAlert.fromJson(Map<String, dynamic> json) {
    return SmsNumberAlert(
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

class Tag {
  final String? id;
  final String? name;

  Tag({this.id, this.name});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(id: json['id'], name: json['name']);
  }
}

class Category {
  final String? id;
  final String? createdDate;
  final String? name;
  final String? lang;
  final String? tagType;
  final String? userId;

  Category({
    this.id,
    this.createdDate,
    this.name,
    this.lang,
    this.tagType,
    this.userId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      createdDate: json['createdDate'],
      name: json['name'],
      lang: json['lang'],
      tagType: json['tagType'],
      userId: json['userId'],
    );
  }
}

class Pageable {
  final Sort? sort;
  final int? offset;
  final int? pageNumber;
  final int? pageSize;
  final bool? paged;
  final bool? unpaged;

  Pageable({
    this.sort,
    this.offset,
    this.pageNumber,
    this.pageSize,
    this.paged,
    this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) {
    return Pageable(
      sort: json['sort'] != null ? Sort.fromJson(json['sort']) : null,
      offset: json['offset'],
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      paged: json['paged'],
      unpaged: json['unpaged'],
    );
  }
}

class Sort {
  final bool? empty;
  final bool? sorted;
  final bool? unsorted;

  Sort({this.empty, this.sorted, this.unsorted});

  factory Sort.fromJson(Map<String, dynamic> json) {
    return Sort(
      empty: json['empty'],
      sorted: json['sorted'],
      unsorted: json['unsorted'],
    );
  }
}
