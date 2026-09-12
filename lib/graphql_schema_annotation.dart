/// Annotations read by `graphql_schema_generator`.
///
/// A Dart model needs none of them: a class is a type, its public instance
/// fields are the fields, an enum is an enum, a sealed class is a union and an
/// abstract class is an interface. These four say what the Dart leaves unsaid.
library;

export 'src/directive.dart';
export 'src/interface.dart';
export 'src/scalar.dart';
export 'src/skip.dart';
