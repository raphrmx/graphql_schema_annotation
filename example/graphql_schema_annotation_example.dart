// The four annotations, on a model that is otherwise plain Dart.
//
// `CompanyDraft` is read in argument position, which is what makes it an input
// type and what the `@_len_12_` on its field needs. A root passes it:
//
//     class Queries {
//       Future<Company?> company(VatNo vatNo) async => ...;
//       Future<Company> upsertCompany(CompanyDraft draft) async => ...;
//     }
//
// `graphql_schema_generator` then writes the following, here with the
// descriptions the `///` comments carry left out:
//
//     directive @_len_12_ on INPUT_FIELD_DEFINITION
//
//     directive @_restricted_to_(role: [Role!]!) on FIELD_DEFINITION
//
//     type Query {
//       company(vatNo: ID!): Company
//       upsertCompany(draft: CompanyDraftInput!): Company!
//     }
//
//     type Company implements Listable & Timestamped {
//       vatNo: ID!
//       label: String!
//       owner: String! @_restricted_to_(role: [staff])
//       createdAt: DateTime!
//     }
//
//     input CompanyDraftInput {
//       vatNo: ID! @_len_12_
//       label: String!
//     }
//
//     scalar DateTime
//
//     interface Listable {
//       label: String!
//     }
//
//     enum Role {
//       customer
//       staff
//     }
//
//     interface Timestamped {
//       createdAt: DateTime!
//     }

import 'package:graphql_schema_annotation/graphql_schema_annotation.dart';

/// The field holds 12 characters forming a Belgian VAT number.
// The directive states the rule in the schema, which enforces nothing. The
// class carrying it asserts the same rule.
@GraphQLDirective(
  name: '_len_12_',
  on: {DirectiveLocation.inputFieldDefinition},
)
class Len12 {
  /// Applies the directive.
  const Len12();
}

/// Restricts the field to certain roles.
// No assert to pair with this one. An annotation has to be a const
// expression, and constant evaluation cannot reach into a list, so a rule
// about `role` can only be checked where the values are read.
@GraphQLDirective(
  name: '_restricted_to_',
  on: {DirectiveLocation.fieldDefinition},
)
class RestrictedTo {
  /// The roles allowed to read the field.
  final List<Role> role;

  /// Applies the directive, allowing [role].
  const RestrictedTo({required this.role});
}

/// Who is asking.
enum Role {
  /// Anyone signed in.
  customer,

  /// Someone working for the company.
  staff,
}

/// A VAT number.
// Carried to the `ID` scalar by the annotation. Without it the schema would
// take the type underneath, `String`.
@GraphQLScalar('ID')
extension type const VatNo(String value) {}

/// Something the catalogue can show on a page.
// An abstract class is an interface, and a class naming it after `implements`
// says so in the schema. Nothing to annotate.
abstract class Listable {
  /// The name shown to a customer.
  String get label;
}

/// Something the catalogue dates.
// Reached through `extends`, which hands the fields over rather than naming
// an interface, so this one says what it is.
@GraphQLInterface()
abstract class Timestamped {
  /// Creates the base.
  const Timestamped();

  /// When the record was created.
  DateTime get createdAt;
}

/// A company, as the schema hands it back.
class Company extends Timestamped implements Listable {
  /// The VAT number the company is registered under.
  final VatNo vatNo;

  @override
  final String label;

  /// Who owns the company.
  @RestrictedTo(role: [Role.staff])
  final String owner;

  @override
  final DateTime createdAt;

  /// Where the rendered page for this company is cached.
  @GraphQLSkip()
  final String cacheKey;

  /// Creates a company.
  const Company({
    required this.vatNo,
    required this.label,
    required this.owner,
    required this.createdAt,
    required this.cacheKey,
  });
}

/// A company, as the caller hands it over.
class CompanyDraft {
  /// The VAT number to register the company under.
  @Len12()
  final VatNo vatNo;

  /// The name to show to a customer.
  final String label;

  /// Creates a draft, refusing a VAT number of the wrong length.
  CompanyDraft({required this.vatNo, required this.label})
      : assert(
          vatNo.value.length == 12,
          'A Belgian VAT number holds 12 characters.',
        );
}
