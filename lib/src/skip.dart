import 'package:meta/meta_meta.dart';

/// Keeps the member it is placed on out of the schema.
///
/// ```dart
/// class Product {
///   /// Where the rendered page for this product is cached.
///   @GraphQLSkip()
///   final String cacheKey;
///
///   const Product({required this.cacheKey});
/// }
/// ```
///
/// It reads the same as naming the member under `skip:` in `pubspec.yaml`, and
/// follows the member when it is renamed.
@Target({TargetKind.field, TargetKind.getter, TargetKind.method})
class GraphQLSkip {
  /// Keeps the member out of the schema.
  const GraphQLSkip();
}
