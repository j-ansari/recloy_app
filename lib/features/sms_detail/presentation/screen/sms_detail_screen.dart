import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/utils.dart';
import '../../data/model/sms_detail_model.dart';

class SmsDetailScreen extends StatefulWidget {
  final String id;

  const SmsDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<SmsDetailScreen> createState() => _SmsDetailScreenState();
}

class _SmsDetailScreenState extends State<SmsDetailScreen> {
  final loadingNotifier = ValueNotifier<bool>(true);
  var smsDetail;

  @override
  void initState() {
    getSmsDetail();
    super.initState();
  }

  Future<void> getSmsDetail() async {
    final dio = Dio();
    final response = await dio.post(
      "${AppStrings.baseUrl}recipient/messages",
      data: dateParams(isDetailSms: true, id: widget.id),
    );
    if (response.statusCode == 200) {
      loadingNotifier.value = false;
      smsDetail = response.data;
    } else {
      loadingNotifier.value = false;
      debugPrint('errrrrrrrrrrrrrrrror');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: loadingNotifier,
      builder: (context, value, _) {
        if (value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          var detail = SmsDetailModel.fromJson(smsDetail);
          if (detail.content!.isEmpty) {
            return const Center(
              child: Text(
                'no item',
                style: TextStyle(fontSize: 16),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: detail.totalElements,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                bool type = detail.content![index].messageType! == "WITHDRAW";
                return Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(0, 1),
                        blurRadius: 2.6,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Type:  ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            detail.content![index].messageType!,
                            style: TextStyle(
                              fontSize: 14,
                              color: type ? Colors.red : Colors.green,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            alignment: Alignment.center,
                            width: 20,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: type
                                  ? Colors.red.withOpacity(0.6)
                                  : Colors.green.withOpacity(0.6),
                            ),
                            child: Icon(
                              type ? Icons.arrow_downward : Icons.arrow_upward,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text(
                            "Amount:  ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "${detail.content?[index].amount}  ",
                            style: TextStyle(
                              fontSize: 18,
                              color: type ? Colors.red : Colors.green,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            "${detail.content?[index].currency}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            'Category:  ',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black45,
                            ),
                          ),
                          Text(
                            "${detail.content?[index].tag?.name}",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                            "Bank name:  ${detail.content?[index].smsNumberAlert?.banks}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            detail.content![index].date!,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
        }
      },
    );
  }
}
