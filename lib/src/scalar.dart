import 'package:meta/meta_meta.dart';

/// Carries the type it is placed on into the schema as the scalar [name].
///
/// ```dart
/// /// The stock keeping unit a product is stored under.
/// @GraphQLScalar('ID')
/// extension type const Sku(String value) {}
/// ```
///
/// A name among `Int`, `Float`, `String`, `Boolean` and `ID` reaches the field
/// as it is. Any other name is declared in the schema as `scalar <name>`.
///
/// Without it, an extension type carries the type underneath, and a class is
/// emitted as an object type or as an input type.
@Target({TargetKind.classType, TargetKind.extensionType, TargetKind.enumType})
class GraphQLScalar {
  /// The name the type carries in the schema.
  final String name;

  /// The URL of the specification of the scalar, printed as `@specifiedBy`.
  final String? specifiedByUrl;

  /// Maps the type to the scalar called [name].
  const GraphQLScalar(this.name, {this.specifiedByUrl});
}
