## 0.1.0

First release.

- `@GraphQLDirective` declares the class it is placed on as a GraphQL
  directive. The fields of the class are the arguments of the directive, and an
  instance of it applies the directive where Dart allows an annotation: a
  class, a field, a getter, a method, a parameter, an enum or one of its
  constants.
- `@GraphQLInterface` publishes an abstract class reached through `extends` as
  a GraphQL interface. One reached through `implements` is already one.
- `@GraphQLScalar` carries a type into the schema under a scalar name, which is
  how an `extension type` reaches `ID`.
- `@GraphQLSkip` keeps a member out of the schema, and follows it when it is
  renamed.
- `DirectiveLocation` holds the 19 locations the GraphQL specification defines.
