import 'dart:io';

import 'package:alpha_task/model/site.dart';
import 'package:alpha_task/tools/TextTools.dart';
import 'package:alpha_task/tools/filter.dart';
import 'package:alpha_task/widget/elem_to_widget.dart';
import 'package:alpha_task/widget/x_list.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SitePage extends StatefulWidget {
  SitePage({@required this.sites, @required this.site});
  final List<Site> sites;
  final Site site;
  SitePageState createState() => SitePageState();
}

class SitePageState extends State<SitePage> {
  // General Params

  List<Site> sites;
  Site site;
  int index = 0;
  double height;
  double width;
  int more = 0;

  // Tools Params

  TextTools textTools = new TextTools();
  Filter filter = new Filter();
  ElemToWidget elemToWidget = new ElemToWidget();

  // Sites List Params

  XList xList;
  List<Site> sortedList = [];
  List<Widget> list = [];

  // Scroller

  ScrollController scrollController;
  int alpha = 0;
  int move = 0;

  @override
  void initState() {
    super.initState();
    sites = widget.sites;
    site = widget.site;
    scrollController = ScrollController();
    if (sites != null) {
      sortedList = filter.filterByDistance(sites, site, site.lat, site.lng);
      for (int i = 0; i < sortedList.length; i++) {
        sortedList[i].visited = 0;
        list.add(elemToWidget.siteSmallWidget(context, i, sortedList[i]));
      }
    }
    xList = new XList(
      list: list,
      onClick: callBack,
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: width,
                child: Stack(
                  children: <Widget>[
                    CarouselSlider(
                      height: width,
                      items: site.images.map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: width,
                              decoration: BoxDecoration(
                                color: Colors.black38,
                                image: DecorationImage(
                                  image: FileImage(new File(i.localPath)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                      viewportFraction: 1.0,
                      onPageChanged: (int i) {
                        setState(() {
                          print(i);
                          alpha = i - index;
                          index = i;
                          if (alpha > 0 &&
                              index >= 5 &&
                              site.images.length > 6) {
                            if (index == site.images.length - 1)
                              move = index - 5;
                            else
                              move++;
                            scrollController.animateTo(12 * move.toDouble(),
                                duration: Duration(milliseconds: 300),
                                curve: Curves.linear);
                          } else if (alpha < 0 &&
                              move > 0 &&
                              index < move + 1) {
                            if (index == 0)
                              move = 0;
                            else
                              move--;
                            scrollController.animateTo(12 * move.toDouble(),
                                duration: Duration(milliseconds: 300),
                                curve: Curves.linear);
                          }
                        });
                      },
                      initialPage: index,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: IgnorePointer(
                        ignoring: true,
                        child: Container(
                          height: 28,
                          width: (site.images.length < 7)
                              ? (10 * site.images.length)
                              : 72,
                          child: ListView.builder(
                            controller: scrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount: site.images.length,
                            itemBuilder: (context, i) {
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: site.images[i].imgId ==
                                            site.images[index].imgId
                                        ? Color.fromRGBO(255, 255, 255, 0.9)
                                        : Color.fromRGBO(255, 255, 255, 0.4)),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                        child: Container(
                          width: width - 80,
                          child: Text(
                            site.siteTitle,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Roboto-Bold',
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                          child: Row(
                            children: <Widget>[
                              Text('${site.rating}',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Colors
                                        .black38, //(type == 0) ? Colors.white : Colors.black38,
                                    fontSize: 14,
                                  )),
                              Container(
                                height: 12,
                                width: 3,
                              ),
                              Container(
                                height: 14,
                                width: 14,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/icons/star_yellow.png'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Text(
                  (more == 0)
                      ? textTools.resizeText(site.siteDescriptionShort, 200)
                      : site.siteDescriptionShort,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (more == 0)
                          more = 1;
                        else
                          more = 0;
                      });
                    },
                    child: Text(
                      (more == 0) ? 'lire la suite' : 'reduire',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),

              // Location

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: Text(
                    'Adresse :',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text(
                    (site.adresse != null) ? site.adresse : 'Unavailable',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),

              // Time

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: Text(
                    'Temps :',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Row(
                    children: <Widget>[
                      available(site.openingTime, site.closingTime),
                      Text(
                        ' - ' + getTime(site.openingTime, site.closingTime),
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Price

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: Text(
                    'Prix :',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text(
                    getPrice(site.prix),
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: (sites != null) ? true : false,
                child: Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 130,
                    child: xList.build(),
                  ),
                ),
              ),),
            ],
          ),
        ),
      ),
    );
  }

  String getTime(String openingTime, String closingTime) {
    if (openingTime == '00:00:00' && closingTime == '00:00:00')
      return '24h/24h';
    else if (openingTime != null && closingTime != null)
      return '${openingTime.substring(0, 2)}h${openingTime.substring(3, 5)} - ${closingTime.substring(0, 2)}h${closingTime.substring(3, 5)}';
    else
      return 'Unavailable';
  }

  Text available(String openingTime, String closingTime) {
    int hour = new DateTime.now().hour;
    if (openingTime != null && closingTime != null) {
      if (openingTime == '00:00:00' && closingTime == '00:00:00')
        return Text(
          'Disponible',
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.green,
            fontSize: 14,
          ),
        );
      else if (hour >= int.parse(openingTime.substring(0, 2)) &&
          hour < int.parse(closingTime.substring(0, 2)))
        return Text(
          'Disponible',
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.green,
            fontSize: 14,
          ),
        );
      else
        return Text(
          'Fermer',
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.red,
            fontSize: 14,
          ),
        );
    } else {
      return Text(
        'Unavailable',
        style: TextStyle(
          fontFamily: 'Roboto',
          color: Colors.red,
          fontSize: 14,
        ),
      );
    }
  }

  String getPrice(int price) {
    if (price == 0)
      return 'Gratuit';
    else
      return '$price MAD';
  }

  void callBack(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SitePage(
        sites: sites,
        site: sortedList[index],
      )),
    );
  }
}
