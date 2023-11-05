import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NumberRow extends StatelessWidget {
  const NumberRow({super.key, required this.variable, required this.title});
  final num? variable;
  final String title;
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    String formattedNumber =
        variable != null ? NumberFormat('#,##0').format(variable!) : " - ";
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                color: colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
          Text(
            "\$$formattedNumber",
            style: TextStyle(color: colorScheme.secondary, fontSize: 16),
          )
        ],
      ),
    );
  }
}
