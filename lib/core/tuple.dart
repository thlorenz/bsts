import 'package:equatable/equatable.dart';

class Tuple<T1, T2> extends Equatable {
  Tuple(this.first, this.second) : super(<dynamic>[first, second]);
  final T1 first;
  final T2 second;
}

class Tuple3<T1, T2, T3> extends Equatable {
  Tuple3(this.first, this.second, this.third)
      : super(<dynamic>[first, second, third]);
  final T1 first;
  final T2 second;
  final T3 third;
}
