import 'package:flutter/material.dart';
// import 'package:veryf_app/static/static.dart';

class ToolBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final double height;

  const ToolBarWidget({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Row(
            children: <Widget>[
              // IconButton(
              //   onPressed: () {},
              //   icon: const Icon(Icons.menu),
              // ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text("Logout"),
              ),
              // MaterialButton(
              //   elevation: 0,
              //   onPressed: () {},
              //   color: primaryColor,
              //   shape: const CircleBorder(),
              //   child: Padding(
              //     padding: const EdgeInsets.all(10.0),
              //     child: Text("DA", style: subtitle1_dark),
              //   ),
              // )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
