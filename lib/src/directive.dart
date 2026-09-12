import 'package:meta/meta_meta.dart';

/// A place a directive may be applied, named as the GraphQL specification
/// names it.
///
/// The eight executable locations describe a query document rather than a
/// schema. A directive may declare them, and a generator that reads Dart
/// sources never applies them.
enum DirectiveLocation {
  /// `QUERY`.
  query('QUERY'),

  /// `MUTATION`.
  mutation('MUTATION'),

  /// `SUBSCRIPTION`.
  subscription('SUBSCRIPTION'),

  /// `FIELD`.
  field('FIELD'),

  /// `FRAGMENT_DEFINITION`.
  fragmentDefinition('FRAGMENT_DEFINITION'),

  /// `FRAGMENT_SPREAD`.
  fragmentSpread('FRAGMENT_SPREAD'),

  /// `INLINE_FRAGMENT`.
  inlineFragment('INLINE_FRAGMENT'),

  /// `VARIABLE_DEFINITION`.
  variableDefinition('VARIABLE_DEFINITION'),

  /// `SCHEMA`.
  schema('SCHEMA'),

  /// `SCALAR`, carried by an extension type or a class marked with
  /// `GraphQLScalar`.
  scalar('SCALAR'),

  /// `OBJECT`, carried by a class emitted as an object type.
  object('OBJECT'),

  /// `FIELD_DEFINITION`, carried by a field of an object type, or by a method
  /// of a root class.
  fieldDefinition('FIELD_DEFINITION'),

  /// `ARGUMENT_DEFINITION`, carried by a parameter of a method of a root
  /// class.
  argumentDefinition('ARGUMENT_DEFINITION'),

  /// `INTERFACE`, carried by a class marked with `GraphQLInterface`.
  interface('INTERFACE'),

  /// `UNION`, carried by a sealed class.
  union('UNION'),

  /// `ENUM`, carried by an enum.
  enumType('ENUM'),

  /// `ENUM_VALUE`, carried by a constant of an enum.
  enumValue('ENUM_VALUE'),

  /// `INPUT_OBJECT`, carried by a class emitted as an input type.
  inputObject('INPUT_OBJECT'),

  /// `INPUT_FIELD_DEFINITION`, carried by a field of an input type.
  inputFieldDefinition('INPUT_FIELD_DEFINITION');

  const DirectiveLocation(this.sdlName);

  /// The name the location carries in the SDL, such as `INPUT_FIELD_DEFINITION`.
  final String sdlName;
}

/// Declares the class it is placed on as a GraphQL directive.
///
/// The class states the directive; an instance of it applies the directive.
/// The fields of the class are the arguments of the directive, and their
/// values come from the constructor call that applies it.
///
/// ```dart
/// /// The field holds 12 characters forming a Belgian VAT number.
/// @GraphQLDirective(name: '_len_12_', on: {DirectiveLocation.inputFieldDefinition})
/// class Len12 {
///   const Len12();
/// }
///
/// class CompanyDraft {
///   @Len12()
///   final String vatNo;
///
///   const CompanyDraft({required this.vatNo});
/// }
/// ```
///
/// The declaration reaches the schema only through a class that is applied
/// somewhere, or through a file named under `include:`.
@Target({TargetKind.classType})
class GraphQLDirective {
  /// The name the directive carries in the schema, without the leading `@`.
  final String name;

  /// The places the directive may be applied. Applying it anywhere else stops
  /// the generator.
  final Set<DirectiveLocation> on;

  /// Whether the directive may be applied more than once at one place.
  final bool repeatable;

  /// Declares a directive called [name], applicable at [on].
  const GraphQLDirective({
    required this.name,
    required this.on,
    this.repeatable = false,
  });
}
