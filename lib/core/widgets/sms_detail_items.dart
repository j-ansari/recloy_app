import 'package:flutter/material.dart';
import 'package:sms_project/core/utils/app_color.dart';

import '../../features/change_category/presentation/screen/change_category_screen.dart';
import '../../features/sms_detail/data/model/sms_detail_model.dart';

class SmsDetailItems extends StatelessWidget {
  final List<Content> contentSmsDetail;
  final ScrollController scrollController;
  final int count;

  const SmsDetailItems({
    Key? key,
    required this.contentSmsDetail,
    required this.scrollController,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (contentSmsDetail.isEmpty) {
      return const Center(
        child: Text(
          'no item',
          style: TextStyle(fontSize: 16),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: contentSmsDetail.length + 1,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          if (contentSmsDetail.length == index) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: index == count
                    ? Container()
                    : const CircularProgressIndicator(),
              ),
            );
          } else {
            bool type = contentSmsDetail[index].messageType! == "WITHDRAW";
            return Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                        'Category:  ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "${contentSmsDetail[index].category?.name}",
                        style: TextStyle(
                          fontSize: 12,
                          color: type ? Colors.red : Colors.green,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        alignment: Alignment.center,
                        width: 15,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: type
                              ? Colors.red.withOpacity(0.6)
                              : Colors.green.withOpacity(0.6),
                        ),
                        child: Icon(
                          type ? Icons.arrow_downward : Icons.arrow_upward,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangeCategoryScreen(
                                categoryName:
                                    contentSmsDetail[index].category!.name!,
                                messageId: contentSmsDetail[index].id!,
                                userId: contentSmsDetail[index].user!.id!,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 30,
                          decoration: BoxDecoration(
                            color: const Color(AppColor.primaryColor),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 3,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: const Text(
                            'change category',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Text(
                        "Amount:  ",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "${contentSmsDetail[index].amount}  ",
                        style: TextStyle(
                          fontSize: 12,
                          color: type ? Colors.red : Colors.green,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "${contentSmsDetail[index].currency}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        "Bank name:  ${contentSmsDetail[index].smsNumberAlert?.banks}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        contentSmsDetail[index].date!,
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
          }
        },
      );
    }
  }
}
