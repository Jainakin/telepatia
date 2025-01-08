import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

// Generic UseCase abstract class (Type for result, Params for parameters)
abstract class UseCase<Type, Params> {
  Future<Either<Exception, Type>> call(Params params);
}

// Optional: Create a NoParams class for use cases without parameters
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
