import 'dart:io';

import 'package:alpha_task/model/site.dart';
import 'package:alpha_task/tools/TextTools.dart';
import 'package:flutter/material.dart';

class CircuitSite {
  CircuitSite({
    @required this.context,
    @required this.site,
    @required this.id,
    @required this.function,
    @required this.sites,
    @required this.circuitSites,
    @required this.width,
  });

  final BuildContext context;
  final int id;
  final Site site;
  final Function(Site site, int i) function;
  final List<Site> sites;
  final List<Site> circuitSites;
  final double width;
  DecorationImage action_icon;

  TextTools textTools = new TextTools();

  void initState() {
    if (site.selected == 0) {
      if (site.linked == 1) {
        action_icon = new DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/icons/plus_btn_red.png'),
        );
      } else {
        action_icon = new DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/icons/plus_btn_blue.png'),
        );
      }
    } else if (site.selected == 1) {
      if (site.hidden == 0) {
        action_icon = new DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/icons/plus_btn_red.png'),
        );
      } else {
        action_icon = new DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/icons/plus_btn_blue.png'),
        );
      }
    }
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
            fontSize: 10,
          ),
        );
      else if (hour >= int.parse(openingTime.substring(0, 2)) &&
          hour < int.parse(closingTime.substring(0, 2)))
        return Text(
          'Disponible',
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.green,
            fontSize: 10,
          ),
        );
      else
        return Text(
          'Fermer',
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.red,
            fontSize: 10,
          ),
        );
    } else {
      return Text(
        'Unavailable',
        style: TextStyle(
          fontFamily: 'Roboto',
          color: Colors.red,
          fontSize: 10,
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

  Widget build() {
    initState();
    //double height = MediaQuery.of(context).size.height / 2.5;
    double height = 250;
    double width = this.width - 32;
    double visibility = 1;

    if (height < 240) height = 240;
    if (width < 240) visibility = 0;

    print('height : $height\n');
    print('width : $width\n');

    if (site.linked == -1)
      return Container(
        height: 0,
        width: 0,
      );
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Container(
        height: height,
        width: width,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(
              height: height,
              width: width / 8,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      height: width / 8 - 10,
                      width: width / 8 - 10,
                      decoration: new BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/icons/circle_grey.png'),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${id + 1}',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Container(
                      height: height - (width / 8) - 10,
                      width: width / 8,
                      decoration: new BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: AssetImage(
                            'assets/icons/line_ile.png',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: height,
              width: width / 8 * 7,
              child: Column(
                children: <Widget>[
                  Container(
                    height: width / 8,
                    width: width / 8 * 7,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(3, 5, 3, 5),
                          child: Container(
                            height: width / 8 / 3,
                            width: width / 8 / 3,
                            decoration: new BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fitHeight,
                                image: AssetImage(
                                  'assets/icons/time.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Text(
                            getTime(site.openingTime, site.closingTime),
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(3, 5, 3, 5),
                          child: available(site.openingTime, site.closingTime),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: height - (width / 8),
                    width: width / 8 * 7,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topCenter,
                          child: GestureDetector(
                            child: Container(
                              height: ((height - (width / 8)) / 6) * 5.4,
                              width: width / 8 * 7,
                              decoration: new BoxDecoration(
                                boxShadow: [
                                  new BoxShadow(
                                      color: Colors.black12,
                                      offset: new Offset(2.0, 2.0),
                                      blurRadius: 5.0,
                                      spreadRadius: 0.5)
                                ],
                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(5.0),
                                  topRight: const Radius.circular(5.0),
                                  bottomLeft: const Radius.circular(5.0),
                                  bottomRight: const Radius.circular(5.0),
                                ),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: ((height - (width / 8)) / 6) * 4,
                                    width: width / 8 * 7,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: (site.images[0].localPath != null) ? FileImage(new File(site.images[0].localPath)) : NetworkImage(site.images[0].imgPath),
                                      ),
                                      borderRadius: new BorderRadius.only(
                                        topLeft: const Radius.circular(5.0),
                                        topRight: const Radius.circular(5.0),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: (height - (width / 8)) / 6 * 1.4,
                                    width: width / 8 * 7,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: new BorderRadius.only(
                                        bottomLeft: const Radius.circular(5.0),
                                        bottomRight: const Radius.circular(5.0),
                                      ),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: (height - (width / 8)) /
                                              6 /
                                              2 *
                                              1.4,
                                          width: width / 8 * 7,
                                          child: Padding(
                                            padding:
                                            EdgeInsets.fromLTRB(5, 5, 5, 0),
                                            child: Stack(
                                              children: <Widget>[
                                                Text(
                                                  site.siteTitle == null
                                                      ? "site title"
                                                      : textTools.resizeText(site.siteTitle, 24),
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    color: Colors.black87,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Opacity(
                                                  opacity: visibility,
                                                  child: Align(
                                                    alignment:
                                                    Alignment.centerRight,
                                                    child: Text(
                                                      '_m - _min',
                                                      style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: (height - (width / 8)) /
                                              6 /
                                              2 *
                                              1.0,
                                          width: width / 8 * 7,
                                          child: Padding(
                                            padding:
                                            EdgeInsets.fromLTRB(5, 0, 5, 5),
                                            child: Row(
                                              children: <Widget>[
                                                Image(
                                                  fit: BoxFit.fitHeight,
                                                  image: AssetImage(
                                                      'assets/icons/price_tag.png'),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      3, 0, 0, 0),
                                                  child: Text(
                                                    getPrice(site.prix),
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 10,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              height: (height - (width / 8)) / 12,
                              width: (height - (width / 8)) / 6,
                              decoration: new BoxDecoration(
                                boxShadow: [
                                  new BoxShadow(
                                      color: Colors.black12,
                                      offset: new Offset(2.0, 2.0),
                                      blurRadius: 3.0,
                                      spreadRadius: 0.1)
                                ],
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/icons/yellow_rectangle.png'),
                                ),
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(3),
                                    child: Center(
                                      widthFactor: 1,
                                      child: Text(
                                        '${site.rating}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.all(3),
                                      child: Center(
                                        widthFactor: 1,
                                        child: Container(
                                          height:
                                          (height - (width / 8)) / 12 - 8,
                                          width:
                                          (height - (width / 8)) / 12 - 8,
                                          decoration: new BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  'assets/icons/star.png'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: ((height - (width / 8)) / 6) * 5.4,
                            width: width / 8 * 7,
                            decoration: new BoxDecoration(
                              boxShadow: [
                                new BoxShadow(
                                    color:
                                    (site.selected == 1 && site.hidden == 1)
                                        ? Colors.white.withOpacity(0.7)
                                        : Colors.white.withOpacity(0.0),
                                    offset: new Offset(0, 0),
                                    blurRadius: 0.0,
                                    spreadRadius: 0.5)
                              ],
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(5.0),
                                topRight: const Radius.circular(5.0),
                                bottomLeft: const Radius.circular(5.0),
                                bottomRight: const Radius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 3),
                              child: InkWell(
                                onTap: () {
//                                  try {
//                                    site.linked = 0;
//                                    print("******");
//                                    for (int i = 0; i < sites.length; i++)
//                                      print(sites[i].siteTitle);
//                                    print("******");
//                                  } catch (e) {
//                                    print("Error!!");
//                                  }
//                                  widget.function(id, site, -1, sites);
//                                  setState(() {
//
//                                  });
                                  if (site.linked == 0 &&
                                      circuitSites != null) {
                                    site.linked = 1;
//                                    action_icon = new DecorationImage(
//                                      fit: BoxFit.cover,
//                                      image: AssetImage(
//                                          "assets/icons/plus_btn_red.png"),
//                                    );
                                    function(site, 1);
                                  } else {
                                    if (circuitSites == null) {
                                      if (site.selected == 0) {
                                        site.linked = -1;
                                        function(site, -1);
                                      } else {
                                        if (site.hidden == 0) {
                                          site.hidden = 1;
                                          function(site, 1);
                                        } else {
                                          site.hidden = 0;
                                          function(site, 0);
                                        }
                                      }
                                    } else {
                                      site.linked = 0;
                                      function(site, 0);
                                      //circuitSites.remove(site);
//                                      action_icon = new DecorationImage(
//                                        fit: BoxFit.cover,
//                                        image: AssetImage(
//                                            "assets/icons/plus_btn_blue.png"),
//                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  height: (height - (width / 8)) / 6,
                                  width: (height - (width / 8)) / 6,
                                  decoration: new BoxDecoration(
                                    image: action_icon,
                                    boxShadow: [
                                      new BoxShadow(
                                          color: Colors.black12,
                                          offset: new Offset(2.0, 2.0),
                                          blurRadius: 5.0,
                                          spreadRadius: 0.5)
                                    ],
                                    borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(15.0),
                                      topRight: const Radius.circular(15.0),
                                      bottomLeft: const Radius.circular(15.0),
                                      bottomRight: const Radius.circular(15.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
