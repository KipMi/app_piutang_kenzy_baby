import 'package:flutter/material.dart';
import 'package:app_piutang_kenzy_baby/utils/screen_size.dart';
import 'package:go_router/go_router.dart'; // Import ScreenSize

class NavigationButton extends StatelessWidget {
  final String routeName;
  final String buttonText;

  const NavigationButton(
      {super.key, required this.routeName, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: InkWell(
          onTap: () {
            context.goNamed(routeName);
          },
          child: Container(
            height: ScreenSize.height! * 0.1,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blue[100]!),
                borderRadius: BorderRadius.circular(5)),
            padding: const EdgeInsets.all(5),
            child: Center(child: Text(buttonText)),
          ),
        ),
      ),
    );
  }
}
