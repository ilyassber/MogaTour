import 'package:flutter/material.dart';

class VList {
  VList({@required this.list, @required this.onClick});

  final Function(int index) onClick;
  final List<Widget> list;

//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    context = this.context;
//    list = widget.list;
//    onClick = widget.onClick;
//  }

  Widget build() {
    return Expanded(
      flex: 8,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(2),
            child: SizedBox(
              child: Padding(
                padding: EdgeInsets.all(4),
                child: GestureDetector(
                  onTap: () {
                    onClick(index);
                  },
                  child: list[index],
                ),
              ),
            ),
          );
        },
      ),

    );
  }
}
