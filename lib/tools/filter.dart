import 'package:alpha_task/model/category.dart';
import 'package:alpha_task/model/site.dart';

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
}
