import 'package:first_lesson/utils/images/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyCustomAppBar extends StatelessWidget implements PreferredSize {
  const MyCustomAppBar(
      {Key? key, required this.onSearchTap,})
      : super(key: key);

  final VoidCallback onSearchTap;
 

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:Color(0xffFEB054).withOpacity(0.6),
      elevation: 0,
      leading: IconButton(
          onPressed: onSearchTap,
          icon: const Icon(
            Icons.search,
            color: Colors.black,
            size: 34,
          )),
      actions: [
        IconButton(onPressed: (){}, icon: Image.asset(AppImages.Homedrawer,scale: 1.3,))
      ],
      systemOverlayStyle:  SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor:const Color(0xffFEB054).withOpacity(0.0),

      ),
    );
  }

  @override
  Widget get child => throw UnimplementedError();

  @override
  Size get preferredSize => const Size(double.infinity, 60);
}