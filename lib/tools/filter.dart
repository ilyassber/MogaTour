import 'package:alpha_task/model/category.dart';
import 'package:alpha_task/model/site.dart';
import 'dart:math';

class Filter {
  List<Site> filterByCategory(
      List<Site> sites, List<Site> toList, Category category) {
    List<Site> filteredList = [];
    for (int i = 0; i < sites.length; i++) {
      if (!toList.contains(sites[i])) {
        for (int j = 0; j < sites[i].categories.length; j++) {
          if (sites[i].categories[j].categoryId == category.categoryId) {
            filteredList.add(sites[i]);
            j = sites[i].categories.length;
          }
        }
      }
    }
    return filteredList;
  }

  List<Site> filterByCharacters(
      List<Site> sites, String input) {
    List<Site> filteredList = [];
    int access;
    for (int i = 0; i < sites.length; i++) {
      access = 1;
      for (int j = 0; j < input.length; j++) {
        if (sites[i].siteTitle[j].toLowerCase() != input[j].toLowerCase())
          access = 0;
      }
      if (access == 1)
        filteredList.add(sites[i]);
    }
    return filteredList;
  }

  List<Site> filterByDistance(List<Site> sites, Site site, double latitude, double longitude) {
    List<Site> filteredList = [];
    List<Site> sitesList = [];
    sitesList.addAll(sites);
    if (site != null)
      sitesList.remove(site);
    while (sitesList.length > 0) {
      int index = 0;
      double cof1 = -1;
      double cof2 = -1;
      for (int i = 0; i < sitesList.length; i++) {
        cof2 = sqrt(pow((sitesList[i].lat - latitude), 2) +
            pow((sitesList[i].lng - longitude), 2));
        if (cof1 != -1 && cof2 <= cof1 || cof1 == -1) {
          cof1 = cof2;
          index = i;
        }
      }
      filteredList.add(sitesList[index]);
      sitesList.removeAt(index);
    }
    return filteredList;
  }
}
