import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sms_project/core/core.dart';

import '../../../../core/utils/utils.dart';
import '../../../features.dart';
import '../../data/model/category_model.dart';
import '../../data/model/changed_category_model.dart';

class ChangeCategoryScreen extends StatefulWidget {
  final String categoryName;
  final String messageId;
  final String userId;

  const ChangeCategoryScreen({
    Key? key,
    required this.categoryName,
    required this.messageId,
    required this.userId,
  }) : super(key: key);

  @override
  State<ChangeCategoryScreen> createState() => _ChangeCategoryScreenState();
}

class _ChangeCategoryScreenState extends State<ChangeCategoryScreen> {
  final getCategoryListNotifier = ValueNotifier<bool>(true);
  final changeCategoryListNotifier = ValueNotifier<bool>(false);
  final categoryNameNotifier = ValueNotifier<String?>('');
  var categoryModel = <CategoryModel>[];
  String? selectedCategoryId;

  @override
  void initState() {
    getCategoryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'change category',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(AppColor.primaryColor),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Color(AppColor.primaryColor),
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: getCategoryListNotifier,
              builder: (context, value, child) {
                if (value) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        child: DropdownButton<String>(
                          hint: const Text(
                            'select category',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                          value: selectedCategoryId,
                          isExpanded: true,
                          icon: const SizedBox(),
                          underline: const SizedBox(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategoryId = value;
                            });
                          },
                          items: categoryModel.map((tag) {
                            return DropdownMenuItem<String>(
                              value: tag.id,
                              child: Text(
                                tag.name ?? '',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                              onTap: () =>
                                  categoryNameNotifier.value = tag.name,
                            );
                          }).toList(),
                        ),
                      ),
                      ValueListenableBuilder<String?>(
                        valueListenable: categoryNameNotifier,
                        builder: (context, value, child) {
                          if (value!.isEmpty) {
                            return const SizedBox();
                          } else {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text('current category:'),
                                      const SizedBox(width: 5),
                                      Text(widget.categoryName),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Text('Your chosen category:'),
                                      const SizedBox(width: 5),
                                      Text(value),
                                    ],
                                  ),
                                  const SizedBox(height: 30),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: ValueListenableBuilder<bool>(
                                      valueListenable:
                                          changeCategoryListNotifier,
                                      builder: (context, value, child) {
                                        if (value) {
                                          return const CircularProgressIndicator();
                                        } else {
                                          return AppButton(
                                            title: 'change category',
                                            onClick: () async {
                                              await changeCategory();
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getCategoryList() async {
    final dio = Dio();
    try {
      final response =
          await dio.get('${AppStrings.baseUrl}category/list/admin');
      if (response.statusCode == 202) {
        for (var tag in response.data) {
          categoryModel.add(CategoryModel.fromJson(tag));
        }
      }
    } on DioError catch (error) {
      debugPrint('getResponse   ${error.response?.data}');
      debugPrint('getResponse   ${error.response?.statusCode}');
    }
    getCategoryListNotifier.value = false;
  }

  Future<void> changeCategory() async {
    changeCategoryListNotifier.value = true;
    final dio = Dio();
    var params = <String, String>{
      "userId": widget.userId,
      "messageId": widget.messageId,
      "categoryId": selectedCategoryId!
    };
    try {
      final response = await dio.put(
        '${AppStrings.baseUrl}recipient/message/category',
        data: params,
      );
      if (response.statusCode == 202) {
        final changedTag = ChangedCategoryModel.fromJson(response.data);
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return ResultDialog(
                icon: Icons.done,
                iconColor: Colors.green,
                result: 'category successful changed',
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    Routes.home,
                    arguments: MainScreenParams(
                      id: changedTag.user!.id!,
                      bankNumber: [changedTag.smsNumberAlert!.alertHead!],
                      imei: changedTag.user!.imei!,
                    ),
                  );
                },
              );
            },
          );
        }
      }
    } on DioError catch (error) {
      debugPrint("$error");
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return ResultDialog(
              icon: Icons.cancel_outlined,
              iconColor: Colors.red,
              result: 'error',
              onTap: () => Navigator.pop(context),
            );
          },
        );
      }
    }
    changeCategoryListNotifier.value = false;
  }
}

class ResultDialog extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String result;
  final VoidCallback onTap;

  const ResultDialog({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.result,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 50,
          ),
          const SizedBox(height: 15),
          Text(result),
          const SizedBox(height: 30),
          AppButton(
            title: 'done',
            width: 100,
            onClick: onTap,
          ),
        ],
      ),
    );
  }
}
