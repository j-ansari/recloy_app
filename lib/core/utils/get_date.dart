Map<String, dynamic> dateParams({
  required bool isDetailSms,
  required String id,
  String? fromDate,
  String? toDate,
  int? page,
  int? size,
}) {
  var date = DateTime.now();
  String? fromDay;
  String? toDay;
  String? month;
  if (date.day < 10) {
    fromDay = "0${date.day - (date.day - 1)}";
    toDay = "0${date.day}";
  } else {
    fromDay = "0${date.day - (date.day - 1)}";
    toDay = "${date.day}";
  }
  if (date.month < 10) {
    month = "0${date.month}";
  } else {
    month = "${date.month}";
  }
  String from = "${date.year}-$month-$fromDay";
  String to = "${date.year}-$month-$toDay";
  if (isDetailSms) {
    return {
      "from": fromDate ?? from,
      "to": toDate ?? to,
      "page": page,
      "size": size,
      "userId": id,
      //"userId": '648b77835402bc781451571e',
    };
  } else {
    return {
      "from": fromDate ?? from,
      "to": toDate ?? to,
      "currencyType": "OMR",
      "userId": id,
      //"userId": '648b77835402bc781451571e',
    };
  }
}
