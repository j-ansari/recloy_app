import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../core/utils/utils.dart';
import '../../../sms_detail/data/model/sms_detail_model.dart';

class DetailData extends StatefulWidget {
  final String id;
  final String tag;
  final String fromDate;
  final String toDate;

  const DetailData({
    Key? key,
    required this.id,
    required this.tag,
    required this.fromDate,
    required this.toDate,
  }) : super(key: key);

  @override
  State<DetailData> createState() => _DetailDataState();
}

class _DetailDataState extends State<DetailData> {
  final loadingNotifier = ValueNotifier<bool>(true);
  late SmsDetailModel detailSms;
  final scrollController = ScrollController();
  var contentSmsDetail = <Content>[];
  int count = 0;
  int page = 0;
  int maxSize = 10;

  @override
  void initState() {
    getDetailSms();
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
    scrollController
      ..removeListener(getWithPaginationSmsDetail)
      ..dispose();
    super.dispose();
  }

  Future<void> getDetailSms() async {
    final dio = Dio();
    var params = <String, dynamic>{
      "from": widget.fromDate,
      "to": widget.toDate,
      "page": page,
      "size": maxSize,
      "userId": widget.id,
      "tag": widget.tag,
    };
    final response = await dio.post(
      "${AppStrings.baseUrl}recipient/messages",
      data: params,
    );
    if (response.statusCode == 200) {
      loadingNotifier.value = false;
      detailSms = SmsDetailModel.fromJson(response.data);
      count = detailSms.totalElements!;
      contentSmsDetail = detailSms.content!;
    } else {
      loadingNotifier.value = false;
      debugPrint('errrrrrrrrrrrrrr');
    }
  }

  Future<void> getWithPaginationSmsDetail() async {
    final dio = Dio();
    if (count > contentSmsDetail.length) {
      page++;
      var params = <String, dynamic>{
        "from": null,
        "to": null,
        "page": page,
        "size": maxSize,
        "userId": widget.id,
        "tag": widget.tag,
      };
      final lazyResponse = await dio.post(
        "${AppStrings.baseUrl}recipient/messages",
        data: params,
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            widget.tag,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: ValueListenableBuilder<bool>(
          valueListenable: loadingNotifier,
          builder: (context, value, _) {
            if (value) {
              return const Center(child: CircularProgressIndicator());
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
    );
  }
}
