import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/sms_detail_items.dart';
import '../../../sms_detail/data/model/sms_detail_model.dart';
import '../../data/model/home_default_model.dart';
import '../../data/model/sms_model.dart';
import 'widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  final String id;
  final String imei;
  final List<String> bankNumber;

  const HomeScreen({
    Key? key,
    required this.id,
    required this.imei,
    required this.bankNumber,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final smsQuery = SmsQuery();
  var smsBody = <String>[];
  var smsAddress = <String>[];
  final smsDetailLoadingNotifier = ValueNotifier<bool>(true);
  final getSmsLoadingNotifier = ValueNotifier<bool>(true);
  final readSmsLoadingNotifier = ValueNotifier<bool>(true);
  final selectedDateNotifier = ValueNotifier<int>(-1);
  final selectedCurrentMonthNotifier = ValueNotifier<bool>(true);
  var smsData;
  String? fromDate;
  String? toDate;
  late SmsDetailModel detailSms;
  final scrollController = ScrollController();
  var contentSmsDetail = <Content>[];
  int count = 0;
  int page = 0;
  int maxSize = 10;
  bool isShowTitle = false;
  final monthExpenseTrendKey = GlobalKey();
  final pastMonthNames = <String>[];
  String currentMonthName = '';
  final colors = <Color>[
    Colors.teal,
    Colors.amber,
    Colors.green,
    Colors.blue,
    Colors.pink,
    Colors.indigoAccent,
    Colors.tealAccent,
    Colors.purpleAccent,
    Colors.deepOrangeAccent,
    Colors.grey,
  ];
  bool isValidCondition = false;

  @override
  void initState() {
    getCurrentAndPastMonthNames();
    getAllDataFirstTime().then((_) => getSmsDetail());
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        getWithPaginationSmsDetail();
      }
    });
    if (UtilPreferences.getBool(Preferences.firstLoginUser) == null) {
      showBottomSheetDialog(
        context: context,
        monthExpenseTrendKey: monthExpenseTrendKey,
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(getWithPaginationSmsDetail)
      ..dispose();
    super.dispose();
  }

  Future<void> getDeviceSms() async {
    if (await getIsValidCondition()) {
      await getDeviceMessage();
    } else {
      await getMyDeviceMessage();
    }
  }

  Future<bool> getIsValidCondition() async {
    final dio = Dio();
    final response = await dio.get("${AppStrings.baseUrl}test");
    if (response.statusCode == 200) {
      isValidCondition = response.data['success'];
    }
    return isValidCondition;
  }

  Future<void> sendSmsData(Map<String, dynamic> smsModel) async {
    final dio = Dio();
    final formatSms = json.encode(smsModel);
    await dio.post("${AppStrings.baseUrl}recipient", data: formatSms);
  }

  Future<void> getSmsData({String? fromDate, String? toDate}) async {
    final dio = Dio();
    final response = await dio.post(
      "${AppStrings.baseUrl}recipient/default/page",
      data: dateParams(
        isDetailSms: false,
        id: widget.id,
        fromDate: fromDate,
        toDate: toDate,
      ),
    );
    if (response.statusCode == 200) {
      smsData = response.data;
      getSmsLoadingNotifier.value = false;
    } else {
      getSmsLoadingNotifier.value = false;
    }
  }

  Future<void> getAllDataFirstTime({String? fromDate, String? toDate}) async {
    readSmsLoadingNotifier.value = true;
    await getDeviceSms().then((_) async {
      readSmsLoadingNotifier.value = false;
      final smsDataList = <SmsData>[];
      for (int i = 0; i < smsBody.length; i++) {
        final smsData = SmsData();
        smsData.content = smsBody[i];
        smsData.address = smsAddress[i];
        smsDataList.add(smsData);
      }
      final smsModel = SmsModel();

      smsModel.mobile = "+989129722933";
      smsModel.imei = widget.imei;
      smsModel.id = widget.id;
      smsModel.from = "";
      smsModel.to = "";
      smsModel.count = smsBody.length;
      smsModel.numberAlert = widget.bankNumber[0];
      smsModel.data = smsDataList;
      sendSmsData(smsModel.toJson()).then((_) => getSmsData());
    });
  }

  Future<void> getSmsDetail({String? fromDate, String? toDate}) async {
    smsDetailLoadingNotifier.value = true;
    final dio = Dio();
    final response = await dio.post(
      "${AppStrings.baseUrl}recipient/messages",
      data: dateParams(
        isDetailSms: true,
        id: widget.id,
        fromDate: fromDate,
        toDate: toDate,
        size: maxSize,
        page: page,
      ),
    );

    if (response.statusCode == 200) {
      detailSms = SmsDetailModel.fromJson(response.data);
      count = detailSms.totalElements!;
      contentSmsDetail = detailSms.content!;
    } else {
      debugPrint('errrrrrrrrrrrrrrrror');
    }
    smsDetailLoadingNotifier.value = false;
  }

  Future<void> getWithPaginationSmsDetail({
    String? fromDate,
    String? toDate,
  }) async {
    final dio = Dio();
    if (count > contentSmsDetail.length) {
      page++;
      final lazyResponse = await dio.post(
        "${AppStrings.baseUrl}recipient/messages",
        data: dateParams(
          isDetailSms: true,
          id: widget.id,
          fromDate: fromDate,
          toDate: toDate,
          size: maxSize,
          page: page,
        ),
      );
      if (lazyResponse.statusCode == 200) {
        late SmsDetailModel lazySmsDetail;
        lazySmsDetail = SmsDetailModel.fromJson(lazyResponse.data);
        contentSmsDetail += lazySmsDetail.content!;
        setState(() {});
      } else {
        debugPrint('errrrrrrrrrrrrrrrror');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ValueListenableBuilder<bool>(
      valueListenable: readSmsLoadingNotifier,
      builder: (context, isReadSms, _) {
        if (isReadSms) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Color(AppColor.primaryColor),
                ),
                SizedBox(height: 10),
                Text(
                  'Reading Your Device SMS Please Wait...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(AppColor.primaryColor),
                  ),
                ),
              ],
            ),
          );
        } else {
          return ValueListenableBuilder<bool>(
            valueListenable: getSmsLoadingNotifier,
            builder: (context, getSmsLoading, _) {
              if (getSmsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                final sms = HomeDefaultModel.fromJson(smsData);
                final tagList = sms.tagList;
                double totalWithdraw = sms.smsDataList?[0].withdraw?.amount;
                fromDate = sms.from;
                toDate = sms.to;
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      width: size.width,
                      height: 55,
                      color: Colors.grey[100],
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  smsBody.clear();
                                  smsAddress.clear();
                                  page = 0;
                                  getSmsLoadingNotifier.value = true;
                                  smsDetailLoadingNotifier.value = true;
                                  selectedCurrentMonthNotifier.value = true;
                                  selectedDateNotifier.value = -1;
                                  await UtilPreferences.remove(
                                    Preferences.lastDateReadSms,
                                  );
                                  await UtilPreferences.setBool(
                                    Preferences.firstReadSms,
                                    true,
                                  );
                                  await getAllDataFirstTime()
                                      .then((value) => getSmsDetail())
                                      .then((value) {
                                    smsDetailLoadingNotifier.value = false;
                                  });
                                },
                                child: const Text(
                                  "RESCAN SMS",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(AppColor.primaryColor),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  page = 0;
                                  getSmsLoadingNotifier.value = true;
                                  await getSmsData();
                                },
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Color(AppColor.primaryColor),
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            AppStrings.appName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(AppColor.primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                const Text(
                                  "from date:  ",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "$fromDate",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                const Text(
                                  "to date:  ",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "$toDate",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                const Text(
                                  "currency:  ",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "${sms.smsDataList?[0].currency}",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height / 2.3,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PieChart(
                            PieChartData(
                              sectionsSpace: 0,
                              pieTouchData: PieTouchData(
                                touchCallback: (_, p1) {
                                  final touchedSectionIndex =
                                      p1?.touchedSection?.touchedSectionIndex ??
                                          -1;
                                  if (touchedSectionIndex >= 0) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ShowChartDetail(
                                          index: touchedSectionIndex,
                                          id: widget.id,
                                          color: colors,
                                          tagList: tagList!,
                                          currency:
                                              sms.smsDataList![0].currency!,
                                          fromDate: fromDate!,
                                          toDate: toDate!,
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                              sections: List.generate(
                                tagList!.length,
                                (index) {
                                  double percent = tagList[index].percent;
                                  double sum = tagList[index].tagSum;
                                  isShowTitle = tagList[index].percent > 5;
                                  double fontSize =
                                      tagList[index].percent > 10 ? 9 : 8;
                                  return PieChartSectionData(
                                    color: tagList[index].tag == "UNKNOWN"
                                        ? Colors.red
                                        : colors[index],
                                    value: percent,
                                    radius: 100,
                                    showTitle: isShowTitle,
                                    badgePositionPercentageOffset: 0.8,
                                    title:
                                        "${tagList[index].tag}\n ${sum.toStringAsFixed(1)}",
                                    titleStyle: TextStyle(fontSize: fontSize),
                                  );
                                },
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            key: monthExpenseTrendKey,
                            children: [
                              Text(
                                "${sms.smsDataList?[0].currency} ${totalWithdraw.toStringAsFixed(1)}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: selectedCurrentMonthNotifier,
                          builder: (context, value, child) {
                            return GestureDetector(
                              onTap: () {
                                if (!smsDetailLoadingNotifier.value) {
                                  if (!value) {
                                    page = 0;
                                    selectedCurrentMonthNotifier.value = true;
                                    selectedDateNotifier.value = -1;
                                    getMonthDateTimes(true, -1);
                                  }
                                }
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 10,
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: value
                                      ? const Color(AppColor.primaryColor)
                                          .withOpacity(0.4)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 1,
                                    color: const Color(AppColor.primaryColor)
                                        .withOpacity(0.4),
                                  ),
                                ),
                                child: Text(
                                  currentMonthName,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              List.generate(pastMonthNames.length, (index) {
                            return ValueListenableBuilder<int>(
                              valueListenable: selectedDateNotifier,
                              builder: (context, selectedDate, child) {
                                return GestureDetector(
                                  onTap: () {
                                    if (!smsDetailLoadingNotifier.value) {
                                      if (selectedDate != index) {
                                        page = 0;
                                        selectedDateNotifier.value = index;
                                        selectedCurrentMonthNotifier.value =
                                            false;
                                        getMonthDateTimes(false, index * 2);
                                      }
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 10,
                                    ),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: selectedDate == index
                                          ? const Color(AppColor.primaryColor)
                                              .withOpacity(0.4)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 1,
                                        color:
                                            const Color(AppColor.primaryColor)
                                                .withOpacity(0.4),
                                      ),
                                    ),
                                    child: Text(
                                      pastMonthNames[index],
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ValueListenableBuilder<bool>(
                        valueListenable: smsDetailLoadingNotifier,
                        builder: (context, value, _) {
                          if (value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return SmsDetailItems(
                              contentSmsDetail: contentSmsDetail,
                              scrollController: scrollController,
                              count: count,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                );
              }
            },
          );
        }
      },
    );
  }

  Future<void> getCurrentAndPastMonthNames() async {
    initializeDateFormatting();

    final now = DateTime.now();
    final currentMonth = DateFormat.MMMM().format(now);
    currentMonthName = currentMonth;

    for (int i = 1; i <= 3; i++) {
      final pastMonth = DateTime(now.year, now.month - i);
      final pastMonthName = DateFormat.MMMM().format(pastMonth);
      pastMonthNames.add(pastMonthName);
    }
  }

  void getMonthDateTimes(bool isCurrentMonth, int index) {
    final now = DateTime.now();
    final pastMonthDates = <DateTime>[];
    String? fromDay;
    String? toDay;
    String? month;
    if (isCurrentMonth) {
      if (now.day < 10) {
        fromDay = "0${now.day - (now.day - 1)}";
        toDay = "0${now.day}";
      } else {
        fromDay = "0${now.day - (now.day - 1)}";
        toDay = "${now.day}";
      }
      if (now.month < 10) {
        month = "0${now.month}";
      } else {
        month = "${now.month}";
      }
      final currentMonthFromDate = "${now.year}-$month-$fromDay";
      final currentMonthToDate = "${now.year}-$month-$toDay";
      getSmsLoadingNotifier.value = true;
      getSmsData(fromDate: currentMonthFromDate, toDate: currentMonthToDate)
          .then((_) => getSmsDetail(
                fromDate: currentMonthFromDate,
                toDate: currentMonthToDate,
              ));
      return;
    }

    for (int i = 1; i <= 3; i++) {
      final pastMonth = DateTime(now.year, now.month - i);
      final firstDayOfPastMonth = DateTime(pastMonth.year, pastMonth.month);
      final lastDayOfPastMonth = DateTime(
        pastMonth.year,
        pastMonth.month + 1,
        0,
      );
      pastMonthDates.add(firstDayOfPastMonth);
      pastMonthDates.add(lastDayOfPastMonth);
    }
    late String fromDatePastMonth;
    late String toDatePastMonth;
    for (int i = 0; i < pastMonthDates.length; i += 2) {
      if (pastMonthDates[i].day < 10) {
        fromDay = "0${pastMonthDates[i].day}";
        toDay = "${pastMonthDates[i + 1].day}";
      } else {
        fromDay = "0${pastMonthDates[i].day}";
        toDay = "${pastMonthDates[i + 1].day}";
      }
      if (pastMonthDates[i].month < 10) {
        month = "0${pastMonthDates[i].month}";
      } else {
        month = "${pastMonthDates[i].month}";
      }
      fromDatePastMonth = "${pastMonthDates[i].year}-$month-$fromDay";
      toDatePastMonth = "${pastMonthDates[i + 1].year}-$month-$toDay";
      if (i == index) {
        getSmsLoadingNotifier.value = true;
        getSmsData(fromDate: fromDatePastMonth, toDate: toDatePastMonth)
            .then((_) => getSmsDetail(
                  fromDate: fromDatePastMonth,
                  toDate: toDatePastMonth,
                ));
        break;
      }
    }
  }

  Future<void> getMyDeviceMessage() async {
    var flagForLastDate = false;
    final messageList = await smsQuery.querySms(kinds: [SmsQueryKind.inbox]);
    final newMessage = <String>[];
    final newAddress = <String>[];
    var lastDateInLastMessage = '';
    var lastDateFlag = false;
    for (var sms in messageList) {
      if (await UtilPreferences.get(Preferences.firstReadSms)) {
        smsBody.add(sms.body!);
        smsAddress.add(sms.address!);
        if (flagForLastDate == false) {
          lastDateInLastMessage = sms.date.toString();
          await UtilPreferences.setString(
            Preferences.lastDateReadSms,
            lastDateInLastMessage,
          );
          flagForLastDate = true;
        }
      } else {
        final lastDate = UtilPreferences.getString(
          Preferences.lastDateReadSms,
        );
        final lastDateSavedFromLocalDb =
            DateTime.parse(lastDate!).millisecondsSinceEpoch;
        final fromDateInDevice = sms.date!.millisecondsSinceEpoch;
        if (lastDateSavedFromLocalDb < fromDateInDevice) {
          newMessage.add(sms.body!);
          newAddress.add(sms.address!);
          if (lastDateFlag == false) {
            lastDateInLastMessage = sms.date.toString();
            lastDateFlag = true;
          }
        }
        smsBody = newMessage;
        smsAddress = newAddress;
      }
    }
    if (flagForLastDate == false) {
      if (lastDateInLastMessage.isNotEmpty) {
        await UtilPreferences.setString(
          Preferences.lastDateReadSms,
          lastDateInLastMessage,
        );
        flagForLastDate = true;
      }
    }
    if (await UtilPreferences.get(Preferences.firstReadSms)) {
      await UtilPreferences.setBool(Preferences.firstReadSms, false);
    }
  }

  Future<void> getDeviceMessage() async {
    final bankNumbers = <List<String>>[];
    for (final bankNumber in widget.bankNumber) {
      final splitted = bankNumber.split('\b[^\s]+\b');
      for (int i = 0; i < splitted.length; i++) {
        splitted[i] == splitted[i].trim();
      }
      bankNumbers.add(splitted);
    }

    var flagForLastDate = false;
    final messageList = await smsQuery.querySms(kinds: [SmsQueryKind.inbox]);
    final newMessage = <String>[];
    final newAddress = <String>[];
    var lastDateInLastMessage = '';
    var lastDateFlag = false;
    for (var sms in messageList) {
      final splitted = sms.address?.split('\b[^\s]+\b');
      for (int i = 0; i < splitted!.length; i++) {
        splitted[i] == splitted[i].trim();
      }
      var isValidAddress = true;
      var isBeakLoop = false;
      for (int i = 0; i < bankNumbers.length; i++) {
        // if (!isValidAddress) {
        //   break;
        // }
        if (isBeakLoop) {
          break;
        }
        for (int j = 0; j < splitted.length; j++) {
          // if (!isValidAddress) {
          //   break;
          // }
          if (isBeakLoop) {
            break;
          }
          var validListTemp = bankNumbers[i];
          for (int k = 0; k < validListTemp.length; k++) {
            if (j == k) {
              if (splitted[j] == validListTemp[k]) {
                isValidAddress = true;
                isBeakLoop = true;
              } else {
                isValidAddress = false;
                isBeakLoop = false;
                break;
              }
            } else {
              continue;
            }
          }
          if (isBeakLoop) {
            break;
          }
        }
      }

      if (isBeakLoop) {
        if (await UtilPreferences.get(Preferences.firstReadSms)) {
          smsBody.add(sms.body!);
          smsAddress.add(sms.address!);
          if (flagForLastDate == false) {
            lastDateInLastMessage = sms.date.toString();
            await UtilPreferences.setString(
              Preferences.lastDateReadSms,
              lastDateInLastMessage,
            );
            flagForLastDate = true;
          }
        } else {
          final lastDate = UtilPreferences.getString(
            Preferences.lastDateReadSms,
          );
          final lastDateSavedFromLocalDb =
              DateTime.parse(lastDate!).millisecondsSinceEpoch;
          final fromDateInDevice = sms.date!.millisecondsSinceEpoch;
          if (lastDateSavedFromLocalDb < fromDateInDevice) {
            newMessage.add(sms.body!);
            newAddress.add(sms.address!);
            if (lastDateFlag == false) {
              lastDateInLastMessage = sms.date.toString();
              lastDateFlag = true;
            }
          }
          smsBody = newMessage;
          smsAddress = newAddress;
        }
      }
    }
    if (flagForLastDate == false) {
      if (lastDateInLastMessage.isNotEmpty) {
        await UtilPreferences.setString(
          Preferences.lastDateReadSms,
          lastDateInLastMessage,
        );
        flagForLastDate = true;
      }
    }
    if (await UtilPreferences.get(Preferences.firstReadSms)) {
      await UtilPreferences.setBool(Preferences.firstReadSms, false);
    }
  }
}
