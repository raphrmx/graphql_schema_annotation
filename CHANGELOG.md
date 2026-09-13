## 0.1.1

- Lowers the Dart floor to 3.3, from 3.8, and accepts `meta` from 1.16.0, the
  last version that carries no Dart floor of its own above 3.0. The annotations
  use nothing newer than 3.3, and what sets the floor now is the `extension
  type` in the example rather than a constraint nothing needed.
- No change to the annotations themselves.

## 0.1.0

First release.

- `@GraphQLDirective` declares the class it is placed on as a GraphQL
  directive. `name:` is what the schema calls it, `on:` lists the locations it
  may be applied at, and `repeatable:` allows it more than once at one place.
- The fields of a directive class are the arguments of the directive. An
  instance of the class applies it, and the values that instance was built with
  become the values of the arguments. Dart allows such an annotation on a
  class, a field, a getter, a method, a parameter, an enum and one of its
  constants.
- `@GraphQLScalar` carries a type into the schema under a scalar name, which is
  how an `extension type` reaches `ID`. `specifiedByUrl:` adds `@specifiedBy`
  to the declaration of a scalar the specification does not define.
- `@GraphQLSkip` keeps a member out of the schema, and follows it when it is
  renamed.
- `@GraphQLInterface` publishes an abstract class reached through `extends` as a
  GraphQL interface. One reached through `implements` is already one and needs
  no annotation.
- `DirectiveLocation` holds the 19 locations the GraphQL specification defines.
  Eight of them describe a query document rather than a schema. A directive can
  declare those, and nothing in Dart can apply them.
- Every annotation carries `@Target`, so writing one where it has no meaning is
  reported by the analyser and fails `dart analyze`, before the generator runs.
