import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';

import 'OrdonnanceController.dart';

class DateFilterWidget extends StatelessWidget {
  final OrdonnanceController controller;

  const DateFilterWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Obx(() => TextButton(
                      onPressed: () => _selectDate(context, true),
                      child: Text(
                        'From: ${DateFormat('MMM dd, yyyy').format(controller.startDate.value)}',
                        style: TextStyle(color: Colors.blue[800]),
                      ),
                    )),
                  ),
                  Expanded(
                    child: Obx(() => TextButton(
                      onPressed: () => _selectDate(context, false),
                      child: Text(
                        'To: ${DateFormat('MMM dd, yyyy').format(controller.endDate.value)}',
                        style: TextStyle(color: Colors.blue[800]),
                      ),
                    )),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => controller.fetchOrdonnancesByDate(),
                child: Text('Apply Filter'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? controller.startDate.value : controller.endDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      if (isStartDate) {
        controller.startDate.value = picked;
      } else {
        controller.endDate.value = picked;
      }
    }
  }
}