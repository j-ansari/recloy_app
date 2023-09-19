class ChangedCategoryModel {
  final String? id;
  final String? date;
  final String? messageHash;
  final String? messageType;
  final double? amount;
  final String? metaData;
  final String? cardNumber;
  final String? operationDate;
  final String? currency;
  final User? user;
  final SmsNumberAlert? smsNumberAlert;
  final Tag? tag;
  final Category? category;
  final double? balanceValue;

  ChangedCategoryModel({
    this.id,
    this.date,
    this.messageHash,
    this.messageType,
    this.amount,
    this.metaData,
    this.cardNumber,
    this.operationDate,
    this.currency,
    this.user,
    this.smsNumberAlert,
    this.tag,
    this.category,
    this.balanceValue,
  });

  factory ChangedCategoryModel.fromJson(Map<String, dynamic> json) {
    return ChangedCategoryModel(
      id: json['id'],
      date: json['date'],
      messageHash: json['messageHash'],
      messageType: json['messageType'],
      amount: json['amount'],
      metaData: json['metaData'],
      cardNumber: json['cardNumber'],
      operationDate: json['operationDate'],
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
  final String? createdDate;
  final String? lastModifiedDate;
  final String? mobile;
  final String? firstName;
  final String? lastName;
  final String? imei;

  User({
    this.id,
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
  final String? alertHead;
  final String? banks;
  final String? country;

  SmsNumberAlert({this.id, this.alertHead, this.banks, this.country});

  factory SmsNumberAlert.fromJson(Map<String, dynamic> json) {
    return SmsNumberAlert(
      id: json['id'],
      alertHead: json['alertHead'],
      banks: json['banks'],
      country: json['country'],
    );
  }
}

class Tag {
  final String? id;
  final String? name;
  final String? lang;
  final String? tagType;
  final String? userId;
  final String? categoryId;

  Tag({
    this.id,
    this.name,
    this.lang,
    this.tagType,
    this.userId,
    this.categoryId,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
      lang: json['lang'],
      tagType: json['tagType'],
      userId: json['userId'],
      categoryId: json['categoryId'],
    );
  }
}

class Category {
  final String? id;
  final String? name;
  final String? lang;
  final String? tagType;
  final String? userId;

  Category({
    this.id,
    this.name,
    this.lang,
    this.tagType,
    this.userId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      lang: json['lang'],
      tagType: json['tagType'],
      userId: json['userId'],
    );
  }
}
