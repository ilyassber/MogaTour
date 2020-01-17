import 'package:flutter/material.dart';

class XList {
  XList({@required this.list, @required this.onClick});

  final Function(int index) onClick;
  final List<Widget> list;

  Widget build() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(2),
          child: SizedBox(
            child: Padding(
              padding: EdgeInsets.all(4),
              child: GestureDetector(
                  onTap: () => {onClick(index)},
              child: list[index],
            ),
          ),
        ),
        );
      },
    );
  }
}
