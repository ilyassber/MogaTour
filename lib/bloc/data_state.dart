import 'package:alpha_task/model/category.dart';
import 'package:alpha_task/model/circuit.dart';
import 'package:alpha_task/model/site.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class DataState extends Equatable {
  DataState([List props = const []]) : super(props);
}

class InitialDataState extends DataState {}

class AfterLoading extends DataState {
  AfterLoading(this.sites, this.categories, this.circuits)
      : super([
          sites,
          categories,
          circuits,
        ]);
  final List<Site> sites;
  final List<Category> categories;
  final List<Circuit> circuits;
}

class DataLoaded extends DataState {}
