import 'package:alpha_task/model/category.dart';
import 'package:alpha_task/model/picture.dart';

class Event {
  int id;
  String title;
  List<Picture> images;
  List<Category> categories;
  Function onClick;
  int key;

  Event({
    this.id,
    this.title,
    this.images,
    this.categories,
    this.onClick,
  });


  Map<String, dynamic> toMap() {
    return {
    };
  }

  static Event fromMap(Map<String, dynamic> map) {
    return Event(
    );
  }
}