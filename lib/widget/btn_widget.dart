import 'package:flutter/material.dart';

class BtnWidget {
  BtnWidget({
    @required this.height,
    @required this.width,
    @required this.size,
    @required this.icon,
    @required this.text,
    @required this.onClick,
  });

  final double height;
  final double width;
  final double size;
  final IconData icon;
  final String text;
  final Function onClick;

  Widget build() {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      shadowColor: Color(0xffffffff).withOpacity(0.5),
      color: Color(0xffffffff).withOpacity(0.7),
      child: InkWell(
        onTap: () {
          if (onClick != null) onClick();
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: height,
          width: width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: (text == null)
              ? Icon(
                  icon,
                  color: Colors.black54,
                  size: size,
                )
              : Text(
                  text,
                  style: TextStyle(
                    fontFamily: 'Roboto-Bold',
                    color: Colors.black54,
                    fontSize: size * 0.7,
                  ),
                ),
        ),
      ),
    );
  }
}
