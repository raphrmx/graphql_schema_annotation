<a alt="ComApps Logo" href="https://comapps.be" target="_blank" rel="noreferrer"><img src="https://www.comapps.be/wp-content/uploads/2026/09/CompleteLogoHorizontalMini.png" style="margin: 15px"></a>

# GraphQL Schema Annotation

[![Build](https://img.shields.io/github/actions/workflow/status/raphrmx/graphql_schema_annotation/ci.yml?branch=main&label=build)](https://github.com/raphrmx/graphql_schema_annotation/actions/workflows/ci.yml)
[![Pub Version](https://img.shields.io/pub/v/graphql_schema_annotation?color=blue)](https://pub.dev/packages/graphql_schema_annotation)
[![Maintainer](https://img.shields.io/badge/Maintainer-Raphael_Vrient-purple)](https://comapps.be)
[![License](https://img.shields.io/badge/Licence-MIT-blue)](/LICENSE)
![Maintenance](https://img.shields.io/badge/Maintained-yes-success)
![Platforms](https://img.shields.io/badge/Platforms-Android,_iOS,_macOS,_Windows,_Linux_Web-22375C.svg)

Four annotations read by
[`graphql_schema_generator`](https://pub.dev/packages/graphql_schema_generator),
which writes a GraphQL schema from the Dart sources of a package.

Start without them. The generator already reads a class as a type, its public
instance fields as the fields, an enum as an enum, a sealed class as a union
and an abstract class as an interface. Reach for one of these when the schema
needs something the Dart has no way of saying.

| Annotation | What it does | Where it goes |
| --- | --- | --- |
| `@GraphQLDirective` | Declares the class as a GraphQL directive | on a class |
| `@GraphQLScalar` | Sends a type to a named scalar, such as `ID` | on a class, an extension type or an enum |
| `@GraphQLSkip` | Keeps a member out of the schema | on a field, a getter or a method |
| `@GraphQLInterface` | Publishes an abstract class a type reaches through `extends` | on a class |

## Install

```yaml
dependencies:
  graphql_schema_annotation: ^0.1.0

dev_dependencies:
  graphql_schema_generator: ^0.1.0
```

Your models import the annotations, so they go in `dependencies`. The
generator is a command that reads your sources and ships with nothing, so it
goes in `dev_dependencies`.

## Directives

A GraphQL field can carry a directive, `@_len_12_` or `@auth`, and a Dart
field has no way of writing one. So here a directive is a class: the class is
the declaration, and an instance of it is an application.

```dart
import 'package:graphql_schema_annotation/graphql_schema_annotation.dart';

/// The field holds 12 characters forming a Belgian VAT number.
@GraphQLDirective(name: '_len_12_', on: {DirectiveLocation.inputFieldDefinition})
class Len12 {
  const Len12();
}

class CompanyDraft {
  @Len12()
  final String vatNo;

  const CompanyDraft({required this.vatNo});
}
```

The class becomes the `directive` line, and the annotated field carries it.
The `///` comment on the class becomes the description of the directive:

```graphql
"""The field holds 12 characters forming a Belgian VAT number."""
directive @_len_12_ on INPUT_FIELD_DEFINITION

input CompanyDraftInput {
  vatNo: String! @_len_12_
}
```

`name:` is what the schema calls the directive. It is not derived from the
class name, so a name no Dart identifier could spell, `_len_12_`, is yours to
write.

### Arguments

Give the class fields and they become the arguments of the directive. Their
values come from the call that applies it.

```dart
/// Restricts the field to certain roles.
@GraphQLDirective(name: '_restricted_to_', on: {DirectiveLocation.fieldDefinition})
class RestrictedTo {
  final List<Role> role;

  const RestrictedTo({required this.role});
}

class Company {
  @RestrictedTo(role: [Role.staff])
  final String owner;

  const Company({required this.owner});
}
```

```graphql
directive @_restricted_to_(role: [Role!]!) on FIELD_DEFINITION

type Company {
  owner: String! @_restricted_to_(role: [staff])
}
```

A default written in the constructor becomes the default of the argument. An
enum used as an argument type reaches the schema on its own, which is where
`Role` above comes from.

### Where a directive may go

`on:` lists the places the schema allows. Apply the directive anywhere else
and the generator stops and names the place, rather than writing a schema no
server would accept.

| Written in Dart on | Reaches |
| --- | --- |
| a class emitted as an object type | `OBJECT` |
| a class emitted as an input type | `INPUT_OBJECT` |
| a field of either | `FIELD_DEFINITION` or `INPUT_FIELD_DEFINITION` |
| a method of a root class | `FIELD_DEFINITION` |
| a parameter of such a method | `ARGUMENT_DEFINITION` |
| an abstract class | `INTERFACE` |
| a sealed class | `UNION` |
| an enum, or one of its constants | `ENUM` or `ENUM_VALUE` |
| a type marked `@GraphQLScalar` | `SCALAR` |

Applying the same directive twice at one place also stops the generator,
unless the declaration says `repeatable: true`.

`DirectiveLocation` holds the 19 locations the specification defines. Eight of
them describe a query document rather than a schema, `QUERY` and `FIELD` among
them. A directive can declare those, and nothing in Dart can apply them.

## Scalars

`@GraphQLScalar` says which GraphQL scalar carries a type. An `extension type`
without it reaches the schema as the type underneath, `String` below, so this
is how a field reaches `ID`.

```dart
/// The stock keeping unit a product is stored under.
@GraphQLScalar('ID')
extension type const Sku(String value) {}
```

```graphql
type Product {
  sku: ID!
}
```

`Int`, `Float`, `String`, `Boolean` and `ID` are the five the specification
defines, and a field reaches them as it is. Any other name is declared in the
schema as `scalar <name>`, and `specifiedByUrl:` adds `@specifiedBy` to that
declaration.

## Skipped members

`@GraphQLSkip` keeps a member out of the schema, so it can stay public in Dart
without being part of your API.

```dart
class Product {
  /// Where the rendered page for this product is cached.
  @GraphQLSkip()
  final String cacheKey;

  const Product({required this.cacheKey});
}
```

The generator also takes a `skip:` list of `ClassName.memberName` in
`pubspec.yaml`, which does the same for a class you cannot annotate. Prefer
the annotation on your own code: it follows the member when you rename it,
where the list goes stale in silence.

## Interfaces

You will rarely need this one. An abstract class is already an interface, and
a class naming it after `implements` already says so in the schema. Neither
needs an annotation.

What inference cannot settle is `extends`. It means implementation reuse, so
the superclass hands its fields to the type and stays out of the schema.
`@GraphQLInterface` is how you ask for it to be published instead.

```dart
/// Something the catalogue dates.
@GraphQLInterface()
abstract class Timestamped {
  const Timestamped();

  /// When the record was created.
  DateTime get createdAt;
}

class Product extends Timestamped {
  @override
  final DateTime createdAt;

  const Product({required this.createdAt});
}
```

```graphql
interface Timestamped {
  createdAt: DateTime!
}

type Product implements Timestamped {
  createdAt: DateTime!
}
```

## License

MIT. See [LICENSE](LICENSE).
