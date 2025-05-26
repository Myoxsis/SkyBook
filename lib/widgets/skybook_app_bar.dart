import 'package:flutter/material.dart';

class SkyBookAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool showLogo;

  const SkyBookAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.bottom,
    this.showLogo = true,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          if (showLogo) ...[
            Image.asset('assets/logo_r.png', height: kToolbarHeight - 16),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
      actions: actions,
      bottom: bottom,
    );
  }
}
