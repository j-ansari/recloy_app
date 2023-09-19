class SmsModel {
  String? mobile;
  String? imei;
  String? id;
  String? from;
  String? to;
  int? count;
  String? numberAlert;
  List<SmsData>? data;

  SmsModel({
    this.mobile,
    this.imei,
    this.id,
    this.from,
    this.to,
    this.count,
    this.numberAlert,
    this.data,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['mobile'] = mobile;
    data['imei'] = imei;
    data['id'] = id;
    data['from'] = from;
    data['to'] = to;
    data['count'] = count;
    data['numberAlert'] = numberAlert;
    if (this.data != null) {
      data['data'] = this.data!.map((data) => data.toJson()).toList();
    }
    return data;
  }
}

class SmsData {
  String? address;
  String? content;

  SmsData({this.address, this.content});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['address'] = address;
    data['content'] = content;
    return data;
  }
}
