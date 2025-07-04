import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants.dart';

class PayentMethodButton extends StatelessWidget {
  const PayentMethodButton({
    super.key,
    required this.svgSrc,
    required this.title,
    required this.isActive,
    required this.press,
  });

  final String svgSrc, title;
  final bool isActive;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: press,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(120, 40),
        backgroundColor: isActive ? primaryColor : null,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(
            vertical: defaultPadding / 2, horizontal: defaultPadding * 1.25),
      ),
      icon: SvgPicture.asset(
        svgSrc,
        height: 24,
        width: 24,
        colorFilter: ColorFilter.mode(
          isActive ? Colors.white : Theme.of(context).iconTheme.color!,
          BlendMode.srcIn,
        ),
      ),
      label: Text(
        title,
        style: TextStyle(
          color: isActive
              ? Colors.white
              : Theme.of(context).textTheme.bodyLarge!.color,
        ),
      ),
    );
  }
}
