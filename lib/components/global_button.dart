// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class GlobalButton extends StatelessWidget {
  const GlobalButton({
    Key? key,
    required this.label,
    required this.onTap,
  }) : super(key: key);
  final Widget label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.blueAccent,
        ),
        onPressed: onTap,
        child: label,
      ),
    );
  }
}
