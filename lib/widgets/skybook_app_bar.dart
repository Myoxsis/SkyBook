import 'package:flutter/material.dart';

class SkyBookAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const SkyBookAppBar({Key? key, required this.title, this.actions}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Image.asset('assets/logo.png', height: kToolbarHeight - 16),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      actions: actions,
    );
  }
}
