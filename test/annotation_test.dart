import 'package:graphql_schema_annotation/graphql_schema_annotation.dart';
import 'package:test/test.dart';

/// The locations the GraphQL specification defines, spelled as it spells them.
const Set<String> specifiedLocations = {
  'QUERY',
  'MUTATION',
  'SUBSCRIPTION',
  'FIELD',
  'FRAGMENT_DEFINITION',
  'FRAGMENT_SPREAD',
  'INLINE_FRAGMENT',
  'VARIABLE_DEFINITION',
  'SCHEMA',
  'SCALAR',
  'OBJECT',
  'FIELD_DEFINITION',
  'ARGUMENT_DEFINITION',
  'INTERFACE',
  'UNION',
  'ENUM',
  'ENUM_VALUE',
  'INPUT_OBJECT',
  'INPUT_FIELD_DEFINITION',
};

void main() {
  group('DirectiveLocation', () {
    test('covers the locations of the specification, and no others', () {
      final names = DirectiveLocation.values.map((l) => l.sdlName).toSet();
      expect(names, specifiedLocations);
    });

    test('names each location once', () {
      expect(DirectiveLocation.values.length, specifiedLocations.length);
    });
  });

  group('GraphQLDirective', () {
    test('is not repeatable unless it says so', () {
      const directive = GraphQLDirective(
        name: '_len_12_',
        on: {DirectiveLocation.inputFieldDefinition},
      );

      expect(directive.name, '_len_12_');
      expect(directive.on, {DirectiveLocation.inputFieldDefinition});
      expect(directive.repeatable, isFalse);
    });

    test('keeps every location it is given', () {
      const directive = GraphQLDirective(
        name: '_audited_',
        on: {DirectiveLocation.object, DirectiveLocation.fieldDefinition},
        repeatable: true,
      );

      expect(directive.on, hasLength(2));
      expect(directive.repeatable, isTrue);
    });
  });

  group('GraphQLScalar', () {
    test('carries a name and no URL by default', () {
      const scalar = GraphQLScalar('ID');

      expect(scalar.name, 'ID');
      expect(scalar.specifiedByUrl, isNull);
    });

    test('carries the URL it is given', () {
      const scalar = GraphQLScalar(
        'DateTime',
        specifiedByUrl: 'https://scalars.graphql.org/andimarek/date-time',
      );

      expect(scalar.specifiedByUrl, isNotNull);
    });
  });
}
