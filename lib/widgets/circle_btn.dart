import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final void Function() onPressed;
  const CircleButton(this.icon, {
    required this.onPressed,
    this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: ShapeDecoration(
        color: color ?? Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        ),
     );
  }
}

