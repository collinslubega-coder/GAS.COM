import 'package:flutter/material.dart';

Future<dynamic> customModalBottomSheet(
  BuildContext context, {
  required Widget child,
}) {
  return showModalBottomSheet(
    context: context,
    clipBehavior: Clip.hardEdge,
    isScrollControlled: true,
    builder: (context) => SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: child,
    ),
  );
}