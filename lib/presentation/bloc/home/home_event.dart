
import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeEvent extends HomeEvent {}

class RefreshHomeEvent extends HomeEvent {}

class RetryHomeEvent extends HomeEvent {}
