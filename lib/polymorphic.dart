library polymorphic;

import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

export 'package:code_builder/code_builder.dart';

extension type Arity(int value) implements int {}

Iterable<String> _generateLetters(int length) {
  const startingLetter = 65;

  return Iterable.generate(
    length,
    (index) => String.fromCharCode(startingLetter + index),
  );
}

const argRef = Reference('arg');

Iterable<TypeReference> _polyTypes(Arity int) => _generateLetters(int).map(
      (e) => TypeReference((b) {
        b
          ..symbol = e
          ..bound = const Reference('Object?');
      }),
    );

String _polyClassName(String name, Arity arity) => '$name$arity';

String _polyExtensionName(String name, Arity arity) =>
    '${_polyClassName(name, arity)}X';

typedef Context = ({
  Arity arity,
  Iterable<String> letters,
  Iterable<Reference> letterReferences,
});

Context _createContext(Arity arity) {
  final letters = _generateLetters(arity);

  return (
    arity: arity,
    letters: letters,
    letterReferences: letters.map(Reference.new),
  );
}

typedef Poly<B, U> = ({
  String name,
  U Function(B) updates,
});

typedef ExtensionUpdates = ({
  Iterable<Method> methods,
  Iterable<Reference> on,
});

typedef Extension$ = Poly<Context, ExtensionUpdates>;

extension Extension$X on Extension$ {
  Extension build(Arity arity) => Extension((b) {
        final (:on, :methods) = updates(_createContext(arity));
        b
          ..name = _polyExtensionName(name, arity)
          ..types.replace(_polyTypes(arity))
          ..on = RecordType(
            (b) => b.positionalFieldTypes.replace(on),
          )
          ..methods.addAll(methods);
      });
}

typedef ClassContext = ({
  Context inner,
  ClassBuilder b,
});

typedef Class$ = Poly<ClassContext, void>;

extension Class$X on Class$ {
  Class build(Arity arity) => Class((b) {
        b
          ..name = _polyClassName(name, arity)
          ..types.replace(_polyTypes(arity));
        updates((
          b: b,
          inner: _createContext(arity),
        ));
      });
}

typedef SpecDescriptions = Iterable<Spec Function(Arity arity)>;

Iterable<Spec> _createSpecs(SpecDescriptions descriptions) =>
    Iterable.generate(22, (index) => index + 1)
        .map(Arity.new)
        .expand((arity) => descriptions.map((e) => e(arity)));

const _gen = 'gen';

Library _implementationLibrary(SpecDescriptions specs) => Library((b) {
      b
        ..body.addAll(_createSpecs(specs))
        ..directives.add(Directive.partOf('$_gen.dart'));
    });

Future<void> generate(String path, SpecDescriptions specs) {
  final impl = _implementationLibrary(specs).accept(DartEmitter()).toString();
  final code = DartFormatter().format(impl);

  return File('$path/$_gen.g.dart').writeAsString(code);
}
