import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../../core/core.dart';
import '../../../../detail_data/presentation/screen/detail_data.dart';
import '../../../data/model/home_default_model.dart';

class ShowChartDetail extends StatefulWidget {
  final int index;
  final String id;
  final List<Color> color;
  final List<TagList> tagList;
  final String currency;
  final String fromDate;
  final String toDate;

  const ShowChartDetail({
    Key? key,
    required this.index,
    required this.id,
    required this.color,
    required this.tagList,
    required this.currency,
    required this.fromDate,
    required this.toDate,
  }) : super(key: key);

  @override
  State<ShowChartDetail> createState() => _ShowChartDetailState();
}

class _ShowChartDetailState extends State<ShowChartDetail>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Color?> animation;
  late String title;

  @override
  initState() {
    controller = AnimationController(
      duration: const Duration(milliseconds: 1),
      vsync: this,
    );
    final CurvedAnimation curve = CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    );
    animation = ColorTween(
      begin: Colors.white,
      end: Colors.black,
    ).animate(curve);

    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      title: Center(
        child: Text("${widget.tagList[widget.index].tag}"),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size.width / 1.1,
            height: size.height / 4,
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      swapAnimationCurve: Curves.easeIn,
                      swapAnimationDuration: const Duration(seconds: 2),
                      PieChartData(
                        sections: List.generate(
                          widget.tagList.length,
                          (index) {
                            double percent = widget.tagList[index].percent;
                            return PieChartSectionData(
                              color: widget.tagList[index].tag == "UNKNOWN"
                                  ? Colors.red
                                  : widget.color[index],
                              value: percent,
                              radius: 60,
                              showTitle: false,
                              borderSide: index == widget.index
                                  ? BorderSide(
                                      width: 3,
                                      color:
                                          animation.value ?? Colors.transparent,
                                    )
                                  : null,
                              titleStyle: const TextStyle(fontSize: 9),
                            );
                          },
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.currency,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "${widget.tagList[widget.index].tagSum.toStringAsFixed(1)}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 15),
          AppButton(
            title: 'show Detail',
            onClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailData(
                    tag: "${widget.tagList[widget.index].tag}",
                    id: widget.id,
                    fromDate: widget.fromDate,
                    toDate: widget.toDate,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
