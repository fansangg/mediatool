///@author  fansan
///@version 2023/11/24
///@des     add_date_pick_type_dialog

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_tool/util/ui_ext.dart';

import '../common/common_widgets.dart';

class FixChooseTypeDialog extends StatefulWidget {
  final ValueChanged<int> click;

  const FixChooseTypeDialog({super.key, required this.click});

  @override
  State<FixChooseTypeDialog> createState() => _FixChooseTypeDialogState();
}

class _FixChooseTypeDialogState extends State<FixChooseTypeDialog> {

  var type = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      alignment: Alignment.center,
      child: Card(
        child: SizedBox(
          width: Get.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              12.spacerH,
              Text(
                "选择日期数据源",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: RadioListTile<int>(
                        value: 1,
                        title: const Text("添加日期"),
                        groupValue: type,
                        onChanged: (v) {
                          LogUtil.d("changed -- v == $v", tag: "fansangg");
                          setState(() {
                            type = v ?? 0;
                          });
                        }),
                  ),
                  Flexible(
                    child: RadioListTile<int>(
                        value: 2,
                        title: const Text("修改日期"),
                        groupValue: type,
                        onChanged: (v) {
                          LogUtil.d("changed -- v == $v", tag: "fansangg");
                          setState(() {
                            type = v ?? 0;
                          });
                        }),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 1,
                    child: commonButton(() {
                      Get.back();
                    }, " 取消 "),
                  ),
                  18.spacerW,
                  Expanded(
                    flex: 1,
                    child: commonButton(() {
                      Get.back();
                      widget.click.call(type);
                    }, " 确定 "),
                  ),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }
}
