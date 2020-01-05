import 'package:alpha_task/model/picture.dart';
import 'package:alpha_task/settings/settings_state.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  MainPage({@required this.state});

  final SettingsState state;

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  // General Params

  SettingsState state;
  double height;
  double width;
  int index = 0;
  List<Picture> pictures = [
    Picture(
      imgPath: 'assets/images/page_home/1.png',
    ),
    Picture(
      imgPath: 'assets/images/page_home/2.png',
    ),
    Picture(
      imgPath: 'assets/images/page_home/3.png',
    )
  ];
  List<Widget> strings = [];

  @override
  void initState() {
    super.initState();
    state = widget.state;
    strings.addAll([
      Text(
        state.languageMap['most_visited'],
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontFamily: 'Roboto-Light',
        ),
      ),
      Text(
        state.languageMap['near_to_you'],
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontFamily: 'Roboto-Light',
        ),
      ),
      Text(
        state.languageMap['activities'],
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontFamily: 'Roboto-Light',
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Container(
      child: Stack(
        children: <Widget>[
          CarouselSlider(
            height: height,
            items: pictures.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      image: DecorationImage(
                        image: AssetImage(i.imgPath),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 4),
            onPageChanged: (int i) {
              setState(() {
                print(i);
                index = i;
              });
            },
          ),
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.3),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          IgnorePointer(
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, height / 5, 0, 0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      state.languageMap['discover'],
                      style: TextStyle(
                        fontFamily: 'Roboto-Medium',
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 200),
                        child: strings[index],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
