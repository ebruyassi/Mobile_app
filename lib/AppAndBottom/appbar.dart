import 'package:bitirme_prejem/models/style.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppBarMenu extends StatelessWidget implements PreferredSizeWidget {
  const AppBarMenu({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: ThemeText.themColor,
      leading: const Text(''),
      title: const Text(
        textAlign: TextAlign.center,
        "Tavsiye Sepeti",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}
