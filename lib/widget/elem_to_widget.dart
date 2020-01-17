import 'dart:io';

import 'package:alpha_task/model/category.dart';
import 'package:alpha_task/model/site.dart';
import 'package:alpha_task/widget/circuit_site.dart';
import 'package:alpha_task/widget/m_elem.dart';
import 'package:alpha_task/widget/s_elem.dart';
import 'package:alpha_task/widget/x_list.dart';
import 'package:flutter/material.dart';

class ElemToWidget {
  ElemToWidget({this.function});

  final Function(Site site, int i) function;

  Widget siteSmallWidget(BuildContext context, int id, Site site) {
    return SmallElem(
        context: context,
        id: id,
        checked: site.visited,
        title: site.siteTitle,
        distance: null,
        image: new DecorationImage(
          image: (site.images[0].localPath != null) ? FileImage(new File(site.images[0].localPath)) : NetworkImage(site.images[0].imgPath),
          fit: BoxFit.cover,
        ),
        onClick: null).build(context);
  }

  Widget categorySmallWidget(BuildContext context, int id, Category category) {
    return SmallElem(
        context: context,
        id: id,
        checked: 0,
        title: category.categoryName,
        distance: null,
        image: new DecorationImage(
          image: NetworkImage(category.image),
          fit: BoxFit.cover,
        ),
        onClick: null).build(context);
  }

  Widget siteMedWidget(BuildContext context, int id, Site site, double height,
      double width, double fontSize) {
    return MedElem(
        id: id,
        selected: 0,
        title: site.siteTitle,
        image: new DecorationImage(
          image: AssetImage("assets/images/sites/site1.jpeg"),
          fit: BoxFit.cover,
        ),
        onClick: null,
        height: height,
        width: width,
        fontSize: fontSize).build();
  }

  Widget categoryMedWidget(
      BuildContext context,
      int id,
      Category category,
      double height,
      double width,
      double fontSize,
      void Function(int, int) callback) {
    return MedElem(
      id: category.categoryId,
      selected: category.selected,
      title: category.categoryName,
      image: new DecorationImage(
        image: AssetImage("assets/images/circuit_categories/artisanal.jpg"),
        fit: BoxFit.cover,
      ),
      onClick: callback,
      height: height,
      width: width,
      fontSize: fontSize,
    ).build();
  }

  Widget sitesHListWidget(BuildContext context, List<Site> sites) {
    List<Widget> list = [];
    int i = 0;
    while (i < sites.length) {
      list.add(siteMedWidget(context, i, sites[i], 70, 100, 12));
      i++;
    }
    return XList(list: list, onClick: (index) {}).build();
  }

  Widget categoriesHListWidget(BuildContext context, List<Category> categories,
      void Function(int, int) callback) {
    List<Widget> list = [];
    int i = 0;
    while (i < categories.length) {
      list.add(
          categoryMedWidget(context, i, categories[i], 70, 100, 12, callback));
      i++;
    }
    return XList(list: list, onClick: (index) {}).build();
  }

  List<Widget> sitesVListWidget(BuildContext context, List<Site> sites,
      List<Site> circuitSites, void Function(Site, int) refresh, double width) {
    int i = 0;
    List<Widget> circuitWidget = [];
    circuitWidget.clear();
    while (i < sites.length) {
      circuitWidget.add(new CircuitSite(
        context: context,
        site: sites[i],
        id: i,
        sites: sites,
        circuitSites: circuitSites,
        function: refresh,
        width: width,
      ).build());
      i++;
    }
    return circuitWidget;
  }

//  List<Widget> sitesVListWidget(
//      BuildContext context, List<Site> sites, List<Site> to_list) {
//    List<Widget> list = [];
//    int i = 0;
//    while (i < sites.length) {
//      list.add(new CircuitSite(
//        context: context,
//        site: sites[i],
//        id: i,
//        sites: sites,
//        circuitSites: to_list,
//        function: function,
//        width: MediaQuery.of(context).size.width,
//      ).build());
//      i++;
//    }
//    return list;
//    //return VList(context: context, list: list, onClick: (index) {});
//  }
}
