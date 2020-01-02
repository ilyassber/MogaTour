import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class DataState extends Equatable {
  DataState([List props = const []]) : super(props);
}

class InitialDataState extends DataState {}

class AfterLoading extends DataState {
  AfterLoading() : super([]);
}

class DataLoaded extends DataState {}
