import 'package:flutter/material.dart';

class StringRow extends StatelessWidget {
  const StringRow({super.key, required this.variable, required this.title});
  final String variable;
  final String title;
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
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
            variable,
            style: TextStyle(color: colorScheme.secondary, fontSize: 16),
          )
        ],
      ),
    );
  }
}
