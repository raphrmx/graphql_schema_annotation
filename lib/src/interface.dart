import 'package:meta/meta_meta.dart';

/// Publishes an abstract class that a type reaches through `extends` as a
/// GraphQL interface.
///
/// An abstract class reached through `implements` is already one and needs
/// nothing: Dart `implements` is a promise about shape, which is what a
/// GraphQL interface is. `extends` is implementation reuse, so a superclass
/// hands its fields to the type and stays out of the schema, unless it carries
/// this.
///
/// ```dart
/// /// Something the catalogue dates.
/// @GraphQLInterface()
/// abstract class Timestamped {
///   /// Creates the base.
///   const Timestamped();
///
///   /// When the record was created.
///   DateTime get createdAt;
/// }
///
/// class Product extends Timestamped {
///   @override
///   final DateTime createdAt;
///
///   const Product({required this.createdAt});
/// }
/// ```
///
/// ```graphql
/// interface Timestamped {
///   createdAt: DateTime!
/// }
///
/// type Product implements Timestamped {
///   createdAt: DateTime!
/// }
/// ```
@Target({TargetKind.classType})
class GraphQLInterface {
  /// Publishes the class as an interface.
  const GraphQLInterface();
}
