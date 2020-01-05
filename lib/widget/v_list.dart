import 'package:flutter/material.dart';

class VList extends StatefulWidget {
  VList({@required this.context, @required this.list, @required this.onClick});

  final BuildContext context;
  final Function(int index) onClick;
  final List<Widget> list;

  @override
  VListState createState() => VListState();
}

class VListState extends State<VList> {
  @override
  BuildContext context;
  List<Widget> list;
  Function(int index) onClick;

  void refresh () {
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context = widget.context;
    list = widget.list;
    onClick = widget.onClick;
  }

//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    context = this.context;
//    list = widget.list;
//    onClick = widget.onClick;
//  }

  @override
  Widget build(BuildContext context) {
    context = this.context;
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
//                      print("list tap");
//                      refresh();
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
