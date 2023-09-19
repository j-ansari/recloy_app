class HomeDefaultModel {
  final String? from;
  final String? to;
  final List<SmsDataList>? smsDataList;
  final List<TagList>? tagList;

  HomeDefaultModel({this.from, this.to, this.smsDataList, this.tagList});

  factory HomeDefaultModel.fromJson(Map<String, dynamic> json) {
    var smsData = <SmsDataList>[];
    if (json['list'] != null) {
      json['list'].forEach((v) {
        smsData.add(SmsDataList.fromJson(v));
      });
    }
    var tagList = <TagList>[];
    if (json['tagList'] != null) {
      json['tagList'].forEach((v) {
        tagList.add(TagList.fromJson(v));
      });
    }
    return HomeDefaultModel(
      from: json['from'],
      to: json['to'],
      smsDataList: smsData,
      tagList: tagList,
    );
  }
}

class SmsDataList {
  final String? currency;
  final Withdraw? withdraw;
  final Credit? credit;

  SmsDataList({this.currency, this.withdraw, this.credit});

  factory SmsDataList.fromJson(Map<String, dynamic> json) {
    return SmsDataList(
      currency: json['currency'],
      withdraw:
          json['withdraw'] != null ? Withdraw.fromJson(json['withdraw']) : null,
      credit: json['cerdit'] != null ? Credit.fromJson(json['cerdit']) : null,
    );
  }
}

class Withdraw {
  final dynamic amount;
  final dynamic cash;
  final dynamic debit;

  Withdraw({this.amount, this.cash, this.debit});

  factory Withdraw.fromJson(Map<String, dynamic> json) {
    return Withdraw(
      amount: json['amount'],
      cash: json['cash'],
      debit: json['debit'],
    );
  }
}

class Credit {
  final dynamic amount;

  Credit({this.amount});

  factory Credit.fromJson(Map<String, dynamic> json) {
    return Credit(amount: json['amount']);
  }
}

class TagList {
  final int? count;
  final dynamic percent;
  final dynamic tagSum;
  final String? tag;

  TagList({this.count, this.percent, this.tagSum, this.tag});

  factory TagList.fromJson(Map<String, dynamic> json) {
    return TagList(
      count: json['count'],
      percent: json['percent'],
      tagSum: json['tagSum'],
      tag: json['tag'],
    );
  }
}
