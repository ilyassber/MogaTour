import 'package:alpha_task/model/site.dart';

class GeoTools {

  void initSitesGeoPos(List<Site> sites) {
    for (int i = 0; i < sites.length; i++) {
      sites[i].lat = double.parse(sites[i].gpsLocation.split(',')[0]);
      sites[i].lng = double.parse(sites[i].gpsLocation.split(',')[1]);
    }
  }

}