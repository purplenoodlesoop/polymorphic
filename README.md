# `polymorphic`

`polymorphic` is a Dart package that enables pseudopolymorphism, allowing methods to handle a variable number of type parameters using extension methods and records with unnamed fields.

## What is Pseudopolymorphism?

Pseudopolymorphism is a technique where extension methods route based on type parameters. This allows creating methods that can handle a variable number of type parameters by using records with unnamed fields.

## Implementation

This package generates library code that utilizes pseudopolymorphism. It defines extensions/classes for different arities (number of type parameters) and generates the necessary code to handle each case.

## Exposed Functions

### `generate`

```dart
Future<void> generate(String path, SpecDescriptions specs)
```

Generates the implementation library based on the provided specifications and writes the generated code to the specified path.

### `Extension$`

```dart
typedef Extension$ = Poly<Context, ExtensionUpdates>;
```

Defines the structure for creating extensions with variable type parameters.

#### `Extension$X.build`

Provides the `build` method to create an extension for a given arity.

### `Class$`

Defines the structure for creating classes with variable type parameters.

#### `Class$X.build`

Provides the `build` method to create a class for a given arity.

## Usage

To use this package, define your extensions and classes using the provided types and functions, then call `generate` to create the implementation.

For example:

```dart
final Extension$ example = (
  name: 'Example',
  updates: (ctx) {
    return (
      on: ctx.letterReferences,
      methods: [],
    );
  }
);

Future<void> main() => generate('example', [example.build]);
```

This will generate the necessary code to handle the specified extensions and classes with variable type parameters.