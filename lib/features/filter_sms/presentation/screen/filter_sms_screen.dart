import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../core/utils/utils.dart';
import '../../../sms_detail/data/model/sms_detail_model.dart';

class FilterSmsScreen extends StatefulWidget {
  final String id;

  const FilterSmsScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<FilterSmsScreen> createState() => _FilterSmsScreenState();
}

class _FilterSmsScreenState extends State<FilterSmsScreen> {
  final fromDateNotifier = ValueNotifier<String?>('');
  final toDateNotifier = ValueNotifier<String?>('');
  final isShowButtonNotifier = ValueNotifier<bool>(false);
  final loadingNotifier = ValueNotifier<int>(0);
  final searchController = TextEditingController();
  String? fromDate;
  String? toDate;
  late SmsDetailModel detailSms;
  final scrollController = ScrollController();
  var contentSmsDetail = <Content>[];
  int count = 0;
  int page = 0;
  int maxSize = 10;

  @override
  void initState() {
    searchController.addListener(() {
      if (searchController.text.isNotEmpty ||
          fromDate != null && toDate != null) {
        isShowButtonNotifier.value = true;
      } else {
        isShowButtonNotifier.value = false;
      }
    });

    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        getWithPaginationSmsDetail();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController
      ..removeListener(getWithPaginationSmsDetail)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          AppTextField(
            controller: searchController,
            labelText: 'please insert tag name to search',
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  TextButton(
                    onPressed: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2023, 1, 1),
                        lastDate: DateTime(2026, 12, 30),
                      );
                      String? day;
                      String? month;
                      if (date!.day < 10) {
                        day = "0${date.day}";
                      } else {
                        day = "${date.day}";
                      }
                      if (date.month < 10) {
                        month = "0${date.month}";
                      } else {
                        month = "${date.month}";
                      }
                      fromDate = "${date.year}-$month-$day";
                      fromDateNotifier.value = fromDate;
                      isShowButtonNotifier.value =
                          fromDate != null && toDate != null;
                    },
                    child: const Text(
                      'from date',
                      style: TextStyle(
                        color: Color(AppColor.primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ValueListenableBuilder<String?>(
                    valueListenable: fromDateNotifier,
                    builder: (context, value, child) {
                      return Text(
                        value ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      );
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  TextButton(
                    onPressed: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2023, 1, 1),
                        lastDate: DateTime(2026, 12, 30),
                      );
                      String? day;
                      String? month;
                      if (date!.day < 10) {
                        day = "0${date.day}";
                      } else {
                        day = "${date.day}";
                      }
                      if (date.month < 10) {
                        month = "0${date.month}";
                      } else {
                        month = "${date.month}";
                      }
                      toDate = "${date.year}-$month-$day";
                      toDateNotifier.value = toDate;
                      isShowButtonNotifier.value =
                          fromDate != null && toDate != null;
                    },
                    child: const Text(
                      'to date',
                      style: TextStyle(
                        color: Color(AppColor.primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ValueListenableBuilder<String?>(
                    valueListenable: toDateNotifier,
                    builder: (context, value, child) {
                      return Text(
                        value ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          ValueListenableBuilder<bool>(
            valueListenable: isShowButtonNotifier,
            builder: (context, value, child) {
              return AppButton(
                title: 'get details',
                isDisable: !value,
                onClick: () async {
                  await getDetailSms();
                },
              );
            },
          ),
          const SizedBox(height: 20),
          ValueListenableBuilder<int>(
            valueListenable: loadingNotifier,
            builder: (context, value, child) {
              if (value == 0) {
                return const SizedBox();
              } else if (value == 1) {
                return const CircularProgressIndicator();
              } else {
                return Expanded(
                  child: SmsDetailItems(
                    contentSmsDetail: contentSmsDetail,
                    scrollController: scrollController,
                    count: count,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> params() {
    bool isSearchByTag = searchController.text.toUpperCase().isNotEmpty;
    if (isSearchByTag && fromDate != null && toDate != null) {
      return {
        "from": fromDate,
        "to": toDate,
        "page": page,
        "size": maxSize,
        "userId": widget.id,
        "tag": searchController.text.toUpperCase(),
      };
    } else if (fromDate == null || toDate == null) {
      return {
        "page": page,
        "size": maxSize,
        "userId": widget.id,
        "tag": searchController.text.toUpperCase(),
      };
    } else {
      return {
        "from": fromDate,
        "to": toDate,
        "page": page,
        "size": maxSize,
        "userId": widget.id,
      };
    }
  }

  Future<void> getDetailSms() async {
    loadingNotifier.value = 1;
    final dio = Dio();
    final response = await dio.post(
      "${AppStrings.baseUrl}recipient/messages",
      data: params(),
    );
    if (response.statusCode == 200) {
      loadingNotifier.value = 2;
      detailSms = SmsDetailModel.fromJson(response.data);
      count = detailSms.totalElements!;
      contentSmsDetail = detailSms.content!;
    } else {
      loadingNotifier.value = 2;
      debugPrint('errrrrrrrrrrrrrr');
    }
  }

  Future<void> getWithPaginationSmsDetail() async {
    final dio = Dio();
    if (count > contentSmsDetail.length) {
      page++;
      final lazyResponse = await dio.post(
        "${AppStrings.baseUrl}recipient/messages",
        data: params(),
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
}
