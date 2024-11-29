import 'package:polymorphic/polymorphic.dart';

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
